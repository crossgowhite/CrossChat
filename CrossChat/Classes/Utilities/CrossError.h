//
//  CrossXMPPError.h
//  CrossChat
//
//  Created by chaobai on 15/9/24.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

//#import "CrossConstants.h"

#ifndef CROSS_ERROR_H
#define CROSS_ERROR_H
#pragma mark --- xmpp relate string define

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CrossErrorDomainType) {
    CrossErrorDomainTypeNone        = 0,
    CrossErrorDomainTypeXMPP        = 1
};


//const NSString *const CROSSXMPPSSLTrustResultKey          = @"XMPPSSLTrustResultKey";
//const NSString *const CROSSXMPPSSLCertificateDataKey      = @"XMPPSSLCertificateDataKey";
//const NSString *const CROSSXMPPSSLHostnameKey             = @"XMPPSSLHostnameKey";

@class NSXMLElement;

@interface CrossError : NSObject

@property (nonatomic, strong) NSError * error;
@property (nonatomic) CrossErrorDomainType  errorDomainType;

- (id) initWithDomainType: (CrossErrorDomainType)domainType error:(NSError *) newError;
- (NSError *) error;
- (NSInteger) domainType;
//+ (NSError *) errorForXMLElement: (NSXMLElement *)xmlError;
//+ (NSString *) errorStringForXMLElement: (NSXMLElement *)xmlError;
@end

#endif


