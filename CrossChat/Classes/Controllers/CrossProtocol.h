//
//  CrossProtocol.h
//  CrossChat
//
//  Created by chaobai on 15/9/24.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrossProtocolStatus.h"

@class CrossAccount;
@class CrossMessage;


#pragma mark --- protocol relate string define



//Protocol Base
//Base interface for each protocol, it will hide the detail protocol manager to customer
@protocol CrossProtocol <NSObject>

//about account
- (CrossAccount *)getProtocolAccount;
- (id) initWithAccount:(CrossAccount *)newAccount;

//about connection status
- (CrossProtocolConnectionStatus)getProtocolConnectionStatus;

//about message
- (NSString*) sendMessage: (CrossMessage *)newMessage;

//about registerAccount
- (void) registerAccount;

//query avatar info
- (void) fetchAvatarWithName:(NSString*)name;


//about login
- (void) login;
- (void) disconnect;

//query roster info
- (void) queryRoster;

@end



