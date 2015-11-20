//
//  CrossDataBaseView.m
//  CrossChat
//
//  Created by chaobai on 15/9/29.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossDataBaseView.h"
#import "YapDatabaseView.h"
#import "CrossAccountDataBaseManager.h"
#import "CrossBuddyDataBaseManager.h"

#import "CrossBuddy.h"
#import "CrossChatService.h"

NSString * CrossAllAccountDatabaseViewExtensionName =       @"CrossAllAccountDatabaseViewExtensionName";
NSString * CrossAllAccountGroup =                           @"All Accounts";

NSString * CrossAllBuddyDatabaseViewExtensionName =         @"CrossAllBuddyDatabaseViewExtensionName";
NSString * CrossAllBuddyGroup =                             @"All Buddys";

@implementation CrossDataBaseView


+ (BOOL)registerAllAccountsDatabaseView
{
    YapDatabaseView *accountView = [[CrossChatService sharedInstance].accountDataBaseManager.database registeredExtension:CrossAllAccountDatabaseViewExtensionName];
    
    if(accountView)
        return YES;
    
    YapDatabaseViewGrouping * viewGrouping = [YapDatabaseViewGrouping withKeyBlock:^NSString *(NSString *collection, NSString *key) {
        
        if ([collection isEqualToString:[CrossAccount collection]])
        {
            return CrossAllAccountGroup;
        }
        
        return nil;
    }];

    
    YapDatabaseViewSorting *viewSorting = [YapDatabaseViewSorting withObjectBlock:^NSComparisonResult(NSString *group, NSString *collection1, NSString *key1, id object1, NSString *collection2, NSString *key2, id object2) {
        if ([group isEqualToString:CrossAllAccountGroup]) {
            if ([object1 isKindOfClass:[CrossAccount class]] && [object2 isKindOfClass:[CrossAccount class]]) {
                CrossAccount *account1 = (CrossAccount *)object1;
                CrossAccount *account2 = (CrossAccount *)object2;
                return [account1.displayName compare:account2.displayName options:NSCaseInsensitiveSearch];
            }
        }
        return NSOrderedSame;
    }];
    
    YapDatabaseView *databaseView = [[YapDatabaseView alloc] initWithGrouping:viewGrouping
                                                                      sorting:viewSorting
                                                                   versionTag:@"1"
                                                                      options:nil];
    
    return [[CrossChatService sharedInstance].accountDataBaseManager.database registerExtension:databaseView withName:CrossAllAccountDatabaseViewExtensionName];
}


+ (BOOL)registerAllBuddysDatabaseView
{
    YapDatabaseView *buddyView = [[CrossChatService sharedInstance].buddyDataBaseManager.database registeredExtension:CrossAllBuddyDatabaseViewExtensionName];
    
    if(buddyView)
        return YES;
    
    YapDatabaseViewGrouping * viewGrouping = [YapDatabaseViewGrouping withKeyBlock:^NSString *(NSString *collection, NSString *key) {
        
        if ([collection isEqualToString:[CrossBuddy collection]])
        {
            return CrossAllBuddyGroup;
        }
        
        return nil;
    }];
    
    YapDatabaseViewSorting *viewSorting = [YapDatabaseViewSorting withObjectBlock:^NSComparisonResult(NSString *group, NSString *collection1, NSString *key1, id object1, NSString *collection2, NSString *key2, id object2) {
        if ([group isEqualToString:CrossAllBuddyGroup]) {
            if ([object1 isKindOfClass:[CrossBuddy class]] && [object2 isKindOfClass:[CrossBuddy class]]) {
                CrossBuddy *account1 = (CrossBuddy *)object1;
                CrossBuddy *account2 = (CrossBuddy *)object2;
                return [account1.displayName compare:account2.displayName options:NSCaseInsensitiveSearch];
            }
        }
        return NSOrderedSame;
    }];
    
    YapDatabaseView *databaseView = [[YapDatabaseView alloc] initWithGrouping:viewGrouping
                                                                      sorting:viewSorting
                                                                   versionTag:@"1"
                                                                      options:nil];
    
    return [[CrossChatService sharedInstance].buddyDataBaseManager.database registerExtension:databaseView withName:CrossAllBuddyDatabaseViewExtensionName];
}

@end
