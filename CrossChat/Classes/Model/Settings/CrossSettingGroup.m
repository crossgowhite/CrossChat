//
//  CrossSettingGroup.m
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossSettingGroup.h"

@implementation CrossSettingGroup


- (id) initWithTitle:(NSString*)newTitle settings:(NSArray*)newSettings
{
    if (self = [super init])
    {
        _title = newTitle;
        _settings = newSettings;
    }
    return self;
}

@end
