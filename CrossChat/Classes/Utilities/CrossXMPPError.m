//
//  CrossXMPPError.m
//  CrossChat
//
//  Created by chaobai on 15/9/25.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossXMPPError.h"
#import "CrossConstants.h"
#import "XMPPStream.h"

typedef NS_ENUM(NSUInteger, CROSSXMPPStreamErrorCode) {
    CROSSXMPPStreamInvalidType,       // Attempting to access P2P methods in a non-P2P stream, or vice-versa
    CROSSXMPPStreamInvalidState,      // Invalid state for requested action, such as connect when already connected
    CROSSXMPPStreamInvalidProperty,   // Missing a required property, such as myJID
    CROSSXMPPStreamInvalidParameter,  // Invalid parameter, such as a nil JID
    CROSSXMPPStreamUnsupportedAction, // The server doesn't support the requested action
};


@implementation CrossXMPPError

- (id) initWithDomainType: (CrossErrorDomainType)domainType error:(NSError *) newError
{
    self = [super init];
    
    if(self)
    {
        self.errorDomainType = CrossErrorDomainTypeXMPP;
        self.error = [NSError errorWithDomain:CrossXMPPErrorDomain code: [CrossXMPPError getCrossXMPPErrorCode: newError.code ] userInfo:nil];
    }
    return self;
}

+ (CROSSXMPPStreamErrorCode) getCrossXMPPErrorCode: (XMPPStreamErrorCode) newCode
{
    if (newCode == XMPPStreamInvalidType)
        return CROSSXMPPStreamInvalidType;
   
    else if(newCode == XMPPStreamInvalidState)
        return CROSSXMPPStreamInvalidState;
    
    else if (newCode == XMPPStreamInvalidProperty)
        return CROSSXMPPStreamInvalidProperty;
    
    else if (newCode == XMPPStreamInvalidParameter)
        return CROSSXMPPStreamInvalidParameter;
    
    else if (newCode == XMPPStreamUnsupportedAction)
        return CROSSXMPPStreamUnsupportedAction;
    
    return CROSSXMPPStreamInvalidType;
}

- (NSError *)error
{
    return self.error;
}

- (NSInteger)domainType
{
    return self.domainType;
}



@end
