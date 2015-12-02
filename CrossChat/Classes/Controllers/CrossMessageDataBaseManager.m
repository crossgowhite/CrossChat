//
//  CrossMessageDataBaseManager.m
//  CrossChat
//
//  Created by chaobai on 15/11/2.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossMessageDataBaseManager.h"
#import "CrossBuddy.h"
#import "CrossAccount.h"
#import "CrossConstants.h"
#import "CrossChatService.h"

#import "CrossMessage.h"

static NSString * const RootKey = @"Root";

@interface CrossMessageDataBaseManager()

@property (nonatomic, strong) CrossBuddy * buddy;
@property (nonatomic, strong) NSString * dataFilePath;
@property (nonatomic, strong) NSMutableArray * dictArray;
@end

@implementation CrossMessageDataBaseManager

- (id) initWithBuddy:(CrossBuddy*)buddy
{
    self = [super init];
    if (self)
    {
        self.buddy = buddy;
        [self setupDataBase];
    }
    
    return self;
}

- (BOOL) setupDataBase
{
    //1. get database directory
    NSString *databaseDirectory = [[self class] yapDatabaseDirectory];
    NSLog(@"message databaseDirectory : %@",databaseDirectory);
    
    
    //2. create directory if not exsited
    if (![[NSFileManager defaultManager] fileExistsAtPath:databaseDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:databaseDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    self.dataFilePath = [databaseDirectory stringByAppendingPathComponent:[self.buddy.uniqueId stringByAppendingString:CrossMessageDatabaseExtension]];
    
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:self.dataFilePath] )
    {
        [[NSFileManager defaultManager] createFileAtPath:self.dataFilePath contents:nil attributes:nil];
    }
    
    self.dictArray = [NSMutableArray arrayWithContentsOfFile:self.dataFilePath];
    
    if (self.dictArray == nil)
    {
        self.dictArray = [NSMutableArray array];
    }
    
    return YES;
}

+ (NSString *) yapDatabaseDirectory
{
    //1. get sandbox path
    NSString * applicationSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    
    //2. get application name
    NSString * applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    
    //3. database directory = sandbox path + application
    NSString * directory = [applicationSupportDirectory stringByAppendingPathComponent:applicationName];
    
    CrossAccount * account = [[CrossChatService sharedInstance] getServiceAccount];
    NSString * connectAccountUniqedID = account.uniqueId;
    
    //4. final database directory = sandbox path + application + accountname
    NSString * finaldirectory = [directory stringByAppendingPathComponent: connectAccountUniqedID];
    
    return finaldirectory;
}

- (NSArray *) MessageList
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:self.dictArray.count];
    for (NSDictionary * dict in self.dictArray)
    {
        CrossMessage * message = [CrossMessage CrossMessageWithDict:dict];
        [array addObject:message];
    }
    return array;
}

- (void) persistenceMessage:(CrossMessage*)message completeBlock:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        [self.dictArray addObject:[message encodeIntoDictionary]];
        [self.dictArray writeToFile:self.dataFilePath atomically:YES];
        
        if (block)
        {
            block();
        }
    });

}

- (void) updateMessage:(CrossMessage*)message completeBlock:(dispatch_block_t)block
{
    for (int i = 0; i < [self.dictArray count]; i++)
    {
        NSDictionary * dict = [self.dictArray objectAtIndex:i];
        
        CrossMessage * tmpMessage = [CrossMessage CrossMessageWithDict:dict];
        
        if ([tmpMessage.messageID isEqualToString:message.messageID])
        {
            tmpMessage.successSend = [NSNumber numberWithInteger:1];
            [self.dictArray replaceObjectAtIndex:i withObject:[tmpMessage encodeIntoDictionary]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                
                BOOL success = [self.dictArray writeToFile:self.dataFilePath atomically:YES];
                if (success)
                {
                    if (block)
                    {
                        block();
                    }
                }
            });
        }
    }
}


@end
