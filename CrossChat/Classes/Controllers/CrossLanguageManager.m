//
//  CrossLanguageManager.m
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossLanguageManager.h"

@implementation CrossLanguageManager


+ (NSString *)translatedString:(NSString *)translateString{
    return NSLocalizedString(translateString, nil);
}

@end
