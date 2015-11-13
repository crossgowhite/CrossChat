//
//  CrossProtocol.h
//  CrossChat
//
//  Created by chaobai on 15/9/24.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>



@class CrossAccount;
@class CrossMessage;


#pragma mark --- protocol relate string define




typedef NS_ENUM(NSInteger, CrossProtocolType) {
    CrossProtocolTypeNone        = 0,
    CrossProtocolTypeXMPP        = 1
};

typedef NS_ENUM(NSInteger, CrossProtocolConnectionStatus) {
    CrossProtocolConnectionStatusDisconnected        = 0,
    CrossProtocolConnectionStatusConnecting          = 1,
    CrossProtocolConnectionStatusConnected           = 2
};



//Protocol Base
//Base interface for each protocol, it will hide the detail protocol manager to customer
@protocol CrossProtocol <NSObject>

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



