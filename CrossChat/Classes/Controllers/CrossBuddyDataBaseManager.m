//
//  CrossBuddyDataBaseManager.m
//  CrossChat
//
//  Created by chaobai on 15/10/27.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossBuddyDataBaseManager.h"
#import "YapDatabaseSecondaryIndexSetup.h"
#import "YapDatabaseSecondaryIndexHandler.h"
#import "YapDatabaseSecondaryIndex.h"
#import "CrossBuddy.h"

#import "YapDatabaseSecondaryIndexTransaction.h"
#import "YapDatabaseQuery.h"

NSString *const CrossYapDatabseMessageIdSecondaryIndex = @"userName";
NSString *const CrossYapDatabseMessageIdSecondaryIndexExtension = @"CrossYapDatabseMessageIdSecondaryIndexExtension";

@implementation CrossBuddyDataBaseManager


#pragma mark -- singleton instance

- (instancetype)initWithAccountUniqueId:(NSString *)accountName dbName:(NSString *)dbName
{
    if (self = [super init])
    {
        [self setupDataBaseWithAccountUniqueId:accountName dbName:dbName];
    }
    return self;
}

#pragma mark -- setup database

- (BOOL) setupDataBaseWithAccountUniqueId :(NSString *)accountName dbName:(NSString *)dbName
{
    if([self setupYapDataBaseWithAccountUniqueId:accountName dbName:dbName])
    {
        return YES;
    }
    return NO;
}


//use yap database framework to setup
- (BOOL) setupYapDataBaseWithAccountUniqueId :(NSString *)accountName dbName:(NSString *)dbName
{
    if (self.database)
    {
        return YES;
    }
    
    //1. get database directory
    NSString *databaseDirectory = [[self class] yapDatabaseDirectoryWithAccountUniqueId :accountName];
    NSLog(@"buddy databaseDirectory : %@",databaseDirectory);
    
    
    //2. create directory if not exsited
    if (![[NSFileManager defaultManager] fileExistsAtPath:databaseDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:databaseDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //3. get database detail path
    NSString * databasePath = [[self class]yapDatabasePathWithName:dbName AccountUniqueId:accountName];
    
    //4. setup yap data base
    self.database = [[YapDatabase alloc]initWithPath:databasePath];
    
    //5. init database connection
    self.readWriteDatabaseConnection = [self newConnection];
    
    if (![self setupBuddySecondaryIndexes])
        return NO;
    
    if (self.database && self.readWriteDatabaseConnection)
        return YES;
    
    return NO;
}


#pragma mark -- database path etc

+ (NSString *) yapDatabaseDirectoryWithAccountUniqueId:(NSString*)accountName
{
    //1. get sandbox path
    NSString * applicationSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    
    //2. get application name
    NSString * applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    
    //3. database directory = sandbox path + application
    NSString * directory = [applicationSupportDirectory stringByAppendingPathComponent:applicationName];
    
    //4. final database directory = sandbox path + application + accountname
    NSString * finaldirectory = [directory stringByAppendingPathComponent: accountName];
    return finaldirectory;
}

+ (NSString *)yapDatabasePathWithName:(NSString *)name AccountUniqueId:(NSString*)accountName
{
    return [[self yapDatabaseDirectoryWithAccountUniqueId : accountName] stringByAppendingPathComponent:name];
}


#pragma mark -- connection
- (YapDatabaseConnection *) newConnection
{
    return [self.database newConnection];
}

#pragma mark -- buddy list query
- (BOOL)setupBuddySecondaryIndexes
{
    YapDatabaseSecondaryIndexSetup * setup = [ [YapDatabaseSecondaryIndexSetup alloc] init];
    [setup addColumn:CrossYapDatabseMessageIdSecondaryIndex withType:YapDatabaseSecondaryIndexTypeText];
    
    YapDatabaseSecondaryIndexHandler * indexHandler = [YapDatabaseSecondaryIndexHandler withObjectBlock:^(NSMutableDictionary *dict, NSString *collection, NSString *key, id object) {
        if ([object isKindOfClass:[CrossBuddy class]])
        {
            CrossBuddy * buddy = (CrossBuddy *)object;
            
            dict[CrossYapDatabseMessageIdSecondaryIndex] = buddy.userName;
        }
    }];
    
    YapDatabaseSecondaryIndex * secondaryIndex = [[YapDatabaseSecondaryIndex alloc] initWithSetup:setup handler:indexHandler];
    return [self.database registerExtension:secondaryIndex withName:CrossYapDatabseMessageIdSecondaryIndexExtension];
}


- (void)persistenceBuddy:(CrossBuddy*)newBuddy
{
    __block BOOL buddyExisted = NO;
    __block BOOL buddyNeedUpdate = NO;
    
    //save buddy list into db
    [self.readWriteDatabaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        NSString * queryString = [NSString stringWithFormat:@"Where %@ = ?",CrossYapDatabseMessageIdSecondaryIndex];
        YapDatabaseQuery * query = [YapDatabaseQuery queryWithFormat:queryString,newBuddy.userName];
    
        [[transaction ext:CrossYapDatabseMessageIdSecondaryIndexExtension] enumerateKeysAndObjectsMatchingQuery:query
                usingBlock:^(NSString *collection, NSString *key, id object, BOOL *stop) {
                    CrossBuddy * buddy = (CrossBuddy *)object;
                    if (![buddy.userName isEqualToString: newBuddy.userName] || ![buddy.displayName isEqualToString: newBuddy.displayName])
                    {
                        buddyNeedUpdate = YES;
                    }
                    buddyExisted = YES;
                    *stop = YES;
        }];
    }];
    
    if (!buddyExisted || buddyNeedUpdate)
    {
        [self.readWriteDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            [newBuddy saveWithTransaction:transaction];
        }];
    }
}

- (void)persistenceBuddyPhotoWithUserName:(NSString *)username photoData:(NSData*)data
{
    __block CrossBuddy * newbuddy = nil;
    
    [self.readWriteDatabaseConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        NSString * queryString = [NSString stringWithFormat:@"Where %@ = ?",CrossYapDatabseMessageIdSecondaryIndex];
        YapDatabaseQuery * query = [YapDatabaseQuery queryWithFormat:queryString,username];
        
        [[transaction ext:CrossYapDatabseMessageIdSecondaryIndexExtension] enumerateKeysAndObjectsMatchingQuery:query
                 usingBlock:^(NSString *collection, NSString *key, id object, BOOL *stop) {
               CrossBuddy * buddy = (CrossBuddy *)object;
               if ([buddy.userName isEqualToString: username] && ![buddy.avatarData isEqualToData: data])
               {
                   newbuddy = buddy;
               }
        }];
    }];
    
    if (newbuddy)
    {
        newbuddy.avatarData = data;
        
        [self.readWriteDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            [newbuddy saveWithTransaction:transaction];
        }];
    }
}

- (CrossBuddy*) getCrossBuddyByName:(NSString*)username
{
    __block CrossBuddy * newbuddy = nil;
    
    [self.readWriteDatabaseConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        NSString * queryString = [NSString stringWithFormat:@"Where %@ = ?",CrossYapDatabseMessageIdSecondaryIndex];
        YapDatabaseQuery * query = [YapDatabaseQuery queryWithFormat:queryString,username];
        
        [[transaction ext:CrossYapDatabseMessageIdSecondaryIndexExtension] enumerateKeysAndObjectsMatchingQuery:query
                    usingBlock:^(NSString *collection, NSString *key, id object, BOOL *stop) {
                      CrossBuddy * buddy = (CrossBuddy *)object;
                      if ([buddy.userName isEqualToString: username] )
                      {
                          newbuddy = buddy;
                          * stop = YES;
                      }
        }];
    }];
    
    return newbuddy;
}

- (NSArray *)getAllBuddyList
{
    __block NSArray *buddys = nil;
        
    [self.readWriteDatabaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
            buddys = [CrossBuddy allBuddysWithTransaction:transaction];
        }];
        
    return buddys;

}

//all in conversation friend list
- (NSArray *)getInConversationBuddyList
{
    __block NSArray *buddys = nil;
    NSMutableArray * array = [NSMutableArray array];
    [self.readWriteDatabaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
            buddys = [CrossBuddy allBuddysWithTransaction:transaction];
    }];
        
    for (CrossBuddy * buddy in buddys)
    {
        if (buddy.statusMessage != nil)
        {
            [array addObject:buddy];
        }
    }
    return array;

}

- (void)updateBuddyStatusMessage:(NSString*)message buddyName:(NSString*)buddyname completeBlock:(updateBuddy_complete_block_t)block
{
    CrossBuddy * buddy = [self getCrossBuddyByName:buddyname];
    if (buddy)
    {
        buddy.statusMessage = message;
        [self.readWriteDatabaseConnection asyncReadWriteWithBlock: ^(YapDatabaseReadWriteTransaction *transaction)
        {
            [buddy saveWithTransaction:transaction];
        }
        completionBlock:^
        {
            if (block)
                block(buddy);
        }];
    }
}

@end
