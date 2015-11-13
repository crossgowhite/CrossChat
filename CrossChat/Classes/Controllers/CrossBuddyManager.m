//
//  CrossBuddyManager.m
//  CrossChat
//
//  Created by chaobai on 15/10/27.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossBuddyManager.h"
#import "CrossBuddyDataBaseManager.h"
#import "CrossAccount.h"

@interface CrossBuddyManager ()

@property (nonatomic, strong) NSArray * buddyList;

@end

@implementation CrossBuddyManager

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

+ (CrossBuddyManager*) sharedInstance
{
    static id buddyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        buddyManager = [[self alloc] init];
    });
    
    return buddyManager;
}

- (NSArray *)getAllBuddyList
{
    __block NSArray *buddys = nil;
    
    [[CrossBuddyDataBaseManager sharedInstance].readWriteDatabaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        buddys = [CrossBuddy allBuddysWithTransaction:transaction];
    }];
    
    self.buddyList = buddys;
    return self.buddyList;
}

- (NSArray *)getInConversationBuddyList
{
    __block NSArray *buddys = nil;
    NSMutableArray * array = [NSMutableArray array];
    [[CrossBuddyDataBaseManager sharedInstance].readWriteDatabaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
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

@end
