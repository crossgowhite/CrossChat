//
//  CrossProtocolManager.h
//  CrossChat
//
//  Created by chaobai on 15/9/24.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrossProtocol.h"

@class CrossAccount;


@interface CrossProtocolManager : NSObject

@property (nonatomic) NSUInteger numberOfConnectedAccount;

+ (CrossProtocolManager*) sharedInstance; // Singleton method

- (id <CrossProtocol>) protocolForAccount: (CrossAccount *)newAccount;
- (void) removeProtocolForAccount: (CrossAccount *)newAccount;
- (BOOL) existsProtocolForAccount: (CrossAccount *)newAccount;


- (CrossAccount*) connectedAccount;
@end
