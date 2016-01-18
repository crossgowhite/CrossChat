//
//  CrossDataBaseManager.m
//  CrossChat
//
//  Created by chaobai on 15/9/28.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossAccountDataBaseManager.h"
#import "CrossChatService.h"

@interface CrossAccountDataBaseManager ()



@end

@implementation CrossAccountDataBaseManager


#pragma mark -- singleton instance


- (instancetype) initWithDataBaseName :(NSString *)name
{
    if (self = [super init])
    {
        [self setupDataBaseWithName:name];
    }
    return self;
}

#pragma mark -- setup database

- (BOOL) setupDataBaseWithName :(NSString *)name
{
    if([self setupYapDatabaseWithName:name])
    {
        return YES;
    }
    return NO;
}


//use yap database framework to setup
- (BOOL) setupYapDatabaseWithName :(NSString *)name
{
    //1. get database directory
    NSString *databaseDirectory = [[self class] yapDatabaseDirectory];
    NSLog(@"account databaseDirectory : %@",databaseDirectory);
    
    
    //2. create directory if not exsited
    if (![[NSFileManager defaultManager] fileExistsAtPath:databaseDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:databaseDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //3. get database detail path
    NSString * databasePath = [[self class]yapDatabasePathWithName:name];
    
    //4. setup yap data base
    self.database = [[YapDatabase alloc]initWithPath:databasePath];
    
    //5. init database connection
    self.readWriteDatabaseConnection = [self newConnection];
    
    
    if (self.database && self.readWriteDatabaseConnection)
        return YES;
    
    
    return NO;
}


#pragma mark -- database path etc

+ (NSString *) yapDatabaseDirectory
{
    //1. get sandbox path
    NSString * applicationSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    
    //2. get application name
    NSString * applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    
    //3. database directory = sandbox path + application
    NSString * directory = [applicationSupportDirectory stringByAppendingPathComponent:applicationName];
    return directory;
}

+ (NSString *)yapDatabasePathWithName:(NSString *)name
{
    return [[self yapDatabaseDirectory] stringByAppendingPathComponent:name];
}


#pragma mark -- connection
- (YapDatabaseConnection *) newConnection
{
    return [self.database newConnection];
}


#pragma mark -- account query
-(BOOL) accountWhetherExisted:(CrossAccount *)newAccount
{
    __block CrossYapDatabaseObject * item = nil;
    if (self.readWriteDatabaseConnection)
    {
        [self.readWriteDatabaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
            item = [CrossAccount fetchObjectWithUniqueID:newAccount.uniqueId transaction: transaction];
        }];
    }
    
    return item == nil ? NO :YES;
}

-(void)removeAccount:(CrossAccount*)account
{
    [self.readWriteDatabaseConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction){
            [transaction setObject:nil forKey:account.uniqueId inCollection:[CrossAccount collection]];
    }];
    
}



@end
