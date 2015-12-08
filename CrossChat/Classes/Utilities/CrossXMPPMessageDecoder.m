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
    //normal message
    if ([message isChatMessageWithBody])
    {
        CrossMessageType type = [CrossXMPPMessageDecoder getMessageType:message];
        NSString * fromuser = [CrossXMPPMessageDecoder getFromUserNameWithMessage:message];
        
        if (type == CrossMessageText)
        {
            NSString * messageText = [CrossXMPPMessageDecoder getMessageTextWithMessage:message];
            CrossMessage * crossMessage =  [CrossMessage CrossMessageWithText:messageText read:[NSNumber numberWithInteger:1] incoming:[NSNumber numberWithInteger:1] owner:fromuser];
            crossMessage.messageID = [message attributeForName:@"id"].stringValue;
            
            return crossMessage;
        }
        
        else if(type == CrossMessageImage)
        {
            NSString * imageString = [[message elementForName:@"attachment"] stringValue];
            NSData * data = [[NSData alloc]initWithBase64EncodedString:imageString options:0];
            CrossMessage * crossMessage = [CrossMessage CrossMessageWithData:data read:[NSNumber numberWithInteger:1] incoming:[NSNumber numberWithInteger:1] owner:fromuser];
            crossMessage.messageID = [message attributeForName:@"id"].stringValue;
            return crossMessage;
        }
    }
    else
    {
        //received send success message
        NSXMLElement * received = [message elementForName:@"received"];
        if (received)
        {
            if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"])
            {
                NSString * fromuser = [CrossXMPPMessageDecoder getFromUserNameWithMessage:message];
                DDXMLNode * node = [received attributeForName:@"id"];
                NSString * messageId = node.stringValue;
                CrossMessage * crossMessage = [[CrossMessage alloc]init];
                crossMessage.isReponseMessage = [NSNumber numberWithInteger:1];
                crossMessage.messageID = messageId;
                crossMessage.owner = fromuser;
                return crossMessage;
            }
        }
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
    DDXMLNode * from = [message elementForName:@"attachment"];
    
    if (from)
    {
        return CrossMessageImage;
    }
   
    return CrossMessageText;
}

+ (XMPPMessage*) getReceiptsMessageWithXMPPMessage:(XMPPMessage*)message
{
    NSArray * request = [message elementsForName:@"request"];
    XMPPMessage * reponseMessage = nil;
    //create receipts reponse
    if (request)
    {
        if ([message attributeStringValueForName:@"id"])
        {
            reponseMessage = [XMPPMessage messageWithType:[message attributeStringValueForName:@"type"]
                                                       to:message.from];
            NSXMLElement * received = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
            [received addAttributeWithName:@"id" stringValue:[message attributeStringValueForName:@"id"]];
            [reponseMessage addChild:received];
        }
    }
    return reponseMessage;
}

+(NSXMLElement*) createMessageElementWithMessage:(CrossMessage *)message siID:(NSString*)siID
{
    NSXMLElement * sendedmessage = [NSXMLElement elementWithName:@"message"];
    [sendedmessage addAttributeWithName:@"type" stringValue:@"chat"];
    [sendedmessage addAttributeWithName:@"to" stringValue:message.owner];
    [sendedmessage addAttributeWithName:@"id" stringValue:siID];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    
    //image attachmenet
    NSXMLElement *attachment = nil;
    
    //receipts
    NSXMLElement *receipts = nil;
    
    if (message.type == CrossMessageText)
    {
        [body setStringValue:message.text];
    }
    
    else if(message.type == CrossMessageImage)
    {
        NSString * base64str = [message.data base64EncodedStringWithOptions:0];
        attachment = [NSXMLElement elementWithName:@"attachment"];
        [attachment setStringValue:base64str];
        
        receipts = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        
    }
    
    [sendedmessage addChild:body];
    
    if (attachment)
    {
        [sendedmessage addChild:attachment];
    }
    
    if (receipts)
    {
        [sendedmessage addChild:receipts];
    }
    
    return sendedmessage;
}

@end
