//
//  CrossErrorManager.h
//  CrossChat
//
//  Created by chaobai on 15/9/25.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrossError.h"


@interface CrossErrorManager : NSObject



+ (CrossErrorManager*) sharedInstance; // Singleton method
- (CrossError *) errorForDomainType: (CrossErrorDomainType)domainType error:(NSError *) newError;

@end
