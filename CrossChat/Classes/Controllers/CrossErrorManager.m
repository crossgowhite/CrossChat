//
//  CrossErrorManager.m
//  CrossChat
//
//  Created by chaobai on 15/9/25.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossErrorManager.h"
#import "CrossXMPPError.h"

static CrossErrorManager * sharedManger = nil;

@implementation CrossErrorManager

#pragma mark -- Singleton method Create
- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

+ (CrossErrorManager*) sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        sharedManger = [[super allocWithZone:NULL] init];
    });
    return sharedManger;
}

+ (id) allocWithZone: (NSZone *)zone
{
    return [CrossErrorManager sharedInstance];
}

- (id) copyWithZone: (NSZone *)zone
{
    return [CrossErrorManager sharedInstance];
}

//#pragma mark -- init error
- (CrossError *) errorForDomainType: (CrossErrorDomainType)domainType error:(NSError *) newError
{
    CrossError * error = nil;
    switch (domainType) {
        case CrossErrorDomainTypeNone:
            error = [[CrossError alloc]initWithDomainType:domainType error:newError];
            break;
        case CrossErrorDomainTypeXMPP:
            error = [[CrossXMPPError alloc]initWithDomainType:domainType error:newError];
            break;
        default:
            error = [[CrossError alloc]initWithDomainType:domainType error:newError];
            break;
    }
    return error;
}

@end
