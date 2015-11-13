//
//  CrossXMPPError.h
//  CrossChat
//
//  Created by chaobai on 15/9/25.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossError.h"

@interface CrossXMPPError : CrossError

- (id) initWithDomainType: (CrossErrorDomainType)domainType error:(NSError *) newError;
- (NSError *) error;
- (NSInteger) domainType;

@end
