//
//  CrossXMPPAccount.m
//  CrossChat
//
//  Created by chaobai on 15/9/24.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossXMPPAccount.h"
#import "CrossConstants.h"
#import "CrossXMPPManager.h"
#import "String.h"

static NSUInteger const CrossDefaultPortNumber = 5222;

@implementation CrossXMPPAccount

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.domain = XMPP_SERVER_ADDRESS_STRING;
        self.accountType = CrossAccountTypeXMPP;
        self.port = [CrossXMPPAccount defaultPort];
        self.resource = [CrossXMPPAccount newResource];
    }
    return self;
}


- (Class) protocolClass
{
    return [CrossXMPPManager class];
}

- (UIImage *) accountImage
{
    if (self.avatarImageData)
    {
        return [UIImage imageWithData:self.avatarImageData];
    }
    return [UIImage imageNamed: CrossXMPPImageName];
}


- (CrossProtocolType) protocolType
{
    return CrossProtocolTypeXMPP;
}

+ (NSString *) collection
{
    return NSStringFromClass([CrossAccount class]);
}

#pragma mark -- Class Method
+ (int) defaultPort
{
    return CrossDefaultPortNumber;
}

+ (NSString * ) newResource
{
    int r = arc4random() % 99999;
    return [NSString stringWithFormat:@"%@%d",CrossXMPPResource,r];
}

@end
