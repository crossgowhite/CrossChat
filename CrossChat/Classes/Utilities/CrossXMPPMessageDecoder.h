//
//  CrossXMPPMessageDecoder.h
//  CrossChat
//
//  Created by chaobai on 15/11/6.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPMessage.h"


@class CrossMessage;

@interface CrossXMPPMessageDecoder : NSObject

+ (CrossMessage*) getCrossMessageWithXMPPMessage:(XMPPMessage*)message;

+ (NSXMLElement*) createMessageElementWithMessage:(CrossMessage *)message;

@end
