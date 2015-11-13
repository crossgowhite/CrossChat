//
//  CrossXMPPManager.h
//  CrossChat
//
//  Created by chaobai on 15/9/24.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrossProtocol.h"


@class CrossAccount;

@interface CrossXMPPManager : NSObject<CrossProtocol>

#pragma mark -- CrossProtocol Interface 
//about account
- (CrossAccount *)getProtocolAccount;
- (id) initWithAccount:(CrossAccount *)newAccount;

//about connection status
- (CrossProtocolConnectionStatus)getProtocolConnectionStatus;

//about message
- (void) sendMessage: (CrossMessage *)newMessage;

//about registerAccount
- (void) registerAccount;

//about login
- (void) login;
- (void) disconnect;

//query roster info
- (void) queryRoster;

@end
