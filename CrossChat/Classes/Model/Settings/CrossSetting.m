//
//  CrossSetting.m
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossSetting.h"

@implementation CrossSetting

- (id) initWithTitle:(NSString*)newTitle description:(NSString*)newDescription
{
    if (self = [super init])
    {
        _title = newTitle;
        _settingDescription = newDescription;
    }
    return self;
}

@end
