//
//  CrossProtocolStatus.h
//  CrossChat
//
//  Created by chaobai on 15/9/25.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#ifndef CrossChat_CrossProtocolStatus_h
#define CrossChat_CrossProtocolStatus_h
#import <Foundation/Foundation.h>

static NSString * const CrossProtocolLoginSuccess                                    = @"LoginSuccessNotification";
static NSString * const CrossProtocolLoginFailed                                     = @"LoginFailedNotification";

static NSString * const CrossProtocolRegisterSuccess                                 = @"RegisterSuccessNotification";
static NSString * const CrossProtocolRegisterFailed                                  = @"RegisterFailNotification";

static NSString * const CrossProtocolLogouted                                        = @"LogoutedNotification";

typedef NS_ENUM(NSInteger, CrossProtocolType) {
    CrossProtocolTypeNone        = 0,
    CrossProtocolTypeXMPP        = 1
};

typedef NS_ENUM(NSInteger, CrossProtocolConnectionStatus) {
    CrossProtocolConnectionStatusDisconnected        = 0,
    CrossProtocolConnectionStatusConnecting          = 1,
    CrossProtocolConnectionStatusConnected           = 2
};

#endif
