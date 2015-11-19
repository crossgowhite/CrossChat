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
@class CrossMessage;

@interface CrossChatService : NSObject

// Singleton method
+ (CrossChatService*)sharedInstance;

// Get service relate account
- (CrossAccount *)getServiceAccount;

// Login Action
- (BOOL)loginWithAccount:(CrossAccount*)account;

//disconnect Action
- (void)disconnect;

//register account
- (BOOL)registerWithAccount:(CrossAccount*)account;

//about connection status
- (CrossProtocolConnectionStatus)getAccountConnectionStatus;

//about message
- (void)sendMessage:(CrossMessage *)newMessage;

//persistence account into db
- (void)persistenceAccount:(CrossAccount*)account;
@end
