//
//  CrossXMPPMessageDecoder.h
//  CrossChat
//
//  Created by chaobai on 15/11/6.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPMessage.h"

@interface CrossXMPPMessageDecoder : NSObject

+ (NSString *) getFromUserNameWithMessage:(XMPPMessage*)message;

+ (NSString *) getMessageTextWithMessage:(XMPPMessage*)message;
@end
