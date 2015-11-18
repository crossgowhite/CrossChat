//
//  CrossViewManager.m
//  CrossChat
//
//  Created by chaobai on 15/11/16.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossViewManager.h"
#import "CrossSetting.h"
#import "CrossSettingGroup.h"

@implementation CrossViewManager

- (void) initArrayGroups
{
}

- (void) refreshArrayGroup
{
    [self initArrayGroups];
}

- (id) itemAtSection:(NSUInteger)section row:(NSInteger)row
{
    CrossSettingGroup * settingGroup = self.arrayGroups[section];
    CrossSetting * setting = settingGroup.settings[row];
    return setting;
}

- (NSString*) stringForGroupInSection:(NSUInteger)section
{
    CrossSettingGroup * settingGroup = self.arrayGroups[section];
    return settingGroup.title;
}

- (NSUInteger) numberOfItemsInSection:(NSUInteger)section
{
    CrossSettingGroup *settingsGroup = [self.arrayGroups objectAtIndex:section];
    return [settingsGroup.settings count];
}

- (void) cleanArrayGroup
{
    [self.arrayGroups removeAllObjects];
}

@end
