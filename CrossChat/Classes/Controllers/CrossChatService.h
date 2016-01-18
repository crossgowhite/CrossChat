//
//  CrossChatService.h
//  CrossChat
//
//  Created by chaobai on 15/11/19.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrossProtocolStatus.h"

@class CrossAccount;
@class CrossBuddy;
@class CrossMessage;
@class CrossAccountDataBaseManager;
@class CrossBuddyDataBaseManager;
@class CrossMessageManager;


@interface CrossChatService : NSObject

@property (retain, nonatomic) CrossAccount * account;
@property (retain, nonatomic) CrossAccountDataBaseManager * accountDataBaseManager;
@property (retain, nonatomic) CrossBuddyDataBaseManager *   buddyDataBaseManager;
@property (retain, nonatomic) CrossMessageManager *         messageManager;

// Singleton method
+ (CrossChatService*)sharedInstance;

#pragma mark -- Account relate
// Get service relate account
- (CrossAccount *)getServiceAccount;

// Login Action
- (BOOL)loginWithAccount:(CrossAccount*)account;

//disconnect Action
- (void)disconnect;

//register account
- (BOOL)registerWithAccount:(CrossAccount*)account;

//persistence account into db
- (void)persistenceAccount:(CrossAccount*)account;

//about connection status
- (CrossProtocolConnectionStatus)getAccountConnectionStatus;

//remove account
-(void)removeAccount:(CrossAccount*)account;

#pragma mark -- Buddy relate
//all friend list
- (NSArray *)getAllBuddyList;

//all in conversation friend list
- (NSArray *)getInConversationBuddyList;

#pragma mark -- Message relate
//about message
- (NSString*)sendMessage:(CrossMessage *)newMessage completeBlock:(dispatch_block_t)block;

//get message list via buddy
- (NSArray *) MessageListWithBuddy:(CrossBuddy*)buddy;

@end
