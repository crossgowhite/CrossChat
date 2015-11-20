//
//  CrossMessageManager.m
//  CrossChat
//
//  Created by chaobai on 15/11/2.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossMessageManager.h"
#import "CrossBuddy.h"
#import "CrossMessageDataBaseManager.h"

@interface CrossMessageManager()

@property (nonatomic, strong) NSMutableDictionary * databaseManagerDictionary;

@end

@implementation CrossMessageManager

- (id) init
{
    self = [super init];
    if (self)
    {
        self.databaseManagerDictionary = [NSMutableDictionary new];
    }
    return self;
}


- (CrossMessageDataBaseManager*) databaseManagerForBuddy: (CrossBuddy *)buddy
{
    CrossMessageDataBaseManager * databaseManager = [self.databaseManagerDictionary objectForKey:buddy.uniqueId];
    
    if (!databaseManager)
    {
        databaseManager = [[CrossMessageDataBaseManager alloc]initWithBuddy:buddy];
        if (databaseManager)
        {
            [self addDatabaseManager:databaseManager forBuddy:buddy];
        }
    }
    return databaseManager;
}

#pragma mark -- add new & remove protocol into protocolManagerDictionary
- (void) addDatabaseManager: (CrossMessageDataBaseManager*)manager forBuddy: (CrossBuddy *)buddy
{
    @synchronized(self.databaseManagerDictionary)
    {
        [self.databaseManagerDictionary setObject:manager forKey:buddy.uniqueId];
    }
}


- (void) removeProtocolForBuddy: (CrossBuddy *)buddy
{
    @synchronized(self.databaseManagerDictionary)
    {
        CrossMessageDataBaseManager * manager = [self.databaseManagerDictionary objectForKey:buddy.uniqueId];
        
        //remove protocol connectionStatus kvo observer
        if(manager)
        {
            [self.databaseManagerDictionary removeObjectForKey:buddy.uniqueId];
        }
    }
}

- (void)persistenceMessage:(CrossMessage*)message Buddy:(CrossBuddy*)buddy completeBlock:(dispatch_block_t)block
{
    CrossMessageDataBaseManager * messageDataBaseManager =  [self databaseManagerForBuddy:buddy];
    if (messageDataBaseManager)
    {
        [messageDataBaseManager persistenceMessage:message completeBlock:block];
    }
}
@end
