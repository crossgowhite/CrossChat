//
//  CrossXMPPMessageDecoder.m
//  CrossChat
//
//  Created by chaobai on 15/11/6.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossXMPPMessageDecoder.h"

@implementation CrossXMPPMessageDecoder

+ (NSString *) getFromUserNameWithMessage:(XMPPMessage*)message
{
    DDXMLNode * from = [message attributeForName:@"from"];
    NSRange range = [from.stringValue rangeOfString:@"/"];
    return [from.stringValue substringToIndex:range.location];
}

+ (NSString *) getMessageTextWithMessage:(XMPPMessage*)message
{
    NSString * messageText = nil;
    
    if ([message isChatMessageWithBody])
    {
        messageText = message.body;
    }
    return messageText;
}
@end
