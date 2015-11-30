//
//  CrossXMPPMessageDecoder.m
//  CrossChat
//
//  Created by chaobai on 15/11/6.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossXMPPMessageDecoder.h"
#import "CrossMessage.h"
#import "CrossConstants.h"
#import "XMPPFramework.h"

@implementation CrossXMPPMessageDecoder

+ (CrossMessage*) getCrossMessageWithXMPPMessage:(XMPPMessage*)message
{
    CrossMessageType type = [CrossXMPPMessageDecoder getMessageType:message];
    NSString * fromuser = [CrossXMPPMessageDecoder getFromUserNameWithMessage:message];
    
    if (type == CrossMessageText)
    {
        NSString * messageText = [CrossXMPPMessageDecoder getMessageTextWithMessage:message];
        CrossMessage * crossMessage =  [CrossMessage CrossMessageWithText:messageText read:[NSNumber numberWithInteger:1] incoming:[NSNumber numberWithInteger:1] owner:fromuser];
        return crossMessage;
    }
    
    else if(type == CrossMessageImage)
    {
        NSString * imageString = [[message elementForName:@"attachment"] stringValue];
        NSData * data = [[NSData alloc]initWithBase64EncodedString:imageString options:0];
        CrossMessage * crossMessage = [CrossMessage CrossMessageWithData:data read:[NSNumber numberWithInteger:1] incoming:[NSNumber numberWithInteger:1] owner:fromuser];
        return crossMessage;
    }

    return nil;
}

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

+ (CrossMessageType) getMessageType:(XMPPMessage*)message
{
    DDXMLNode * from = [message attributeForName:@"attachment"];
    
    if (from)
    {
        return CrossMessageImage;
    }
   
    return CrossMessageText;
}


+(NSXMLElement*) createMessageElementWithMessage:(CrossMessage *)message
{
    NSXMLElement * sendedmessage = [NSXMLElement elementWithName:@"message"];
    [sendedmessage addAttributeWithName:@"type" stringValue:@"chat"];
    [sendedmessage addAttributeWithName:@"to" stringValue:message.owner];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    NSXMLElement *messagetype = nil;
    
    if (message.type == CrossMessageText)
    {
        [body setStringValue:message.text];
    }
    
    else if(message.type == CrossMessageImage)
    {
        NSString * base64str = [message.data base64EncodedStringWithOptions:0];
        messagetype = [NSXMLElement elementWithName:@"attachment"];
        [messagetype setStringValue:base64str];
    }
    
    [sendedmessage addChild:body];
    if (messagetype)
    {
        [sendedmessage addChild:messagetype];
    }
    
    return sendedmessage;
}

@end
