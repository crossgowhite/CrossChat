//
//  CrossXMPPMessageDecoder.h
//  CrossChat
//
//  Created by chaobai on 15/11/6.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMPPMessage.h"
#import "XMPPIQ.h"
#import "XMPPvCardTemp.h"

@class CrossMessage;
@class CrossBuddy;
@class CrossAccount;

@interface CrossXMPPMessageDecoder : NSObject

+ (CrossMessage*) getCrossMessageWithXMPPMessage:(XMPPMessage*)message;

+ (NSXMLElement*) createMessageElementWithMessage:(CrossMessage *)message siID:(NSString*)siID;

+ (XMPPMessage*) getReceiptsMessageWithXMPPMessage:(XMPPMessage*)message;

+ (NSArray*) getCrossBuddyListWithIQMessage:(XMPPIQ*)message;

+ (CrossAccount*) getAvatarDataWithXMPPvCardTemp:(XMPPvCardTemp*)message;

@end
