//
//  CrossXMPPAccount.h
//  CrossChat
//
//  Created by chaobai on 15/9/24.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossAccount.h"

static NSUInteger const CrossDefaultPortNumber = 5222;

@interface CrossXMPPAccount : CrossAccount

@property (nonatomic, strong) NSString * domain;
@property (nonatomic, strong) NSString * resource;
@property (nonatomic) int                port;

+ (int) defaultPort;

+ (NSString *) newResource;

+ (NSString *) collection;
@end
