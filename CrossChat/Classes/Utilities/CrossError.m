//
//  CrossXMPPError.m
//  CrossChat
//
//  Created by chaobai on 15/9/25.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossError.h"
#import "NSXMLElement+XMPP.h"
#import "XMPPFramework.h"

@interface CrossError ()



@end


@implementation CrossError

- (id) initWithDomainType: (CrossErrorDomainType)domainType error:(NSError *) newError
{
    self = [super init];
    
    if(self)
    {
        self.errorDomainType = CrossErrorDomainTypeNone;
        self.error = [NSError errorWithDomain:newError.domain code:newError.code userInfo:newError.userInfo];
    }
    return self;
}



- (NSError *)error
{
    return self.error;
}

- (NSInteger)domainType
{
    return self.domainType;
}


//+ (NSError *) errorForXMLElement: (NSXMLElement *)xmlError
//{
//    NSString * errorString = [self errorStringForXMLElement: xmlError];
//    
//    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
//    if (errorString)
//    {
//        [userInfo setObject:errorString forKey:NSLocalizedDescriptionKey];
//    }
//    
//    if(xmlError)
//    {
//        [userInfo setObject:xmlError forKey:CROSSXMPPXMLErrorKey];
//    }
//    
//    NSError * error = [NSError errorWithDomain:XMPPStreamErrorDomain code:OTRXMPPXMLError userInfo:userInfo];
//    return error;
//    return nil;
//}
//
//+ (NSString *) errorStringForXMLElement: (NSXMLElement *)xmlError
//{
//    NSString * errorString = nil;
//    NSArray * elements = [xmlError elementsForName:@"error"];
//    if ([elements count])
//    {
//        elements = [[elements firstObject] elementsForName:@"text"];
//        if ([elements count])
//        {
//            errorString = [[elements firstObject] stringValue];
//        }
//    }
//    return errorString;
//}

@end
