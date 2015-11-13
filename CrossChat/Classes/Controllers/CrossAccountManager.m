//
//  CrossAccountManager.m
//  CrossChat
//
//  Created by chaobai on 15/10/20.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossAccountManager.h"
#import "CrossAccountDataBaseManager.h"
#import "CrossAccount.h"
#import "CrossProtocolManager.h"

@implementation CrossAccountManager

+ (NSArray *)allAutoLoginAccounts
{
    __block NSArray *accounts = nil;
    
    [[CrossAccountDataBaseManager sharedInstance].readWriteDatabaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        accounts = [CrossAccount allAccountsWithTransaction:transaction];
    }];

    return accounts;
}

#pragma mark -- get connected account
+ (CrossAccount*) connectedAccount
{
    return [[CrossProtocolManager sharedInstance] connectedAccount];
}
@end
