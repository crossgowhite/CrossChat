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

- (void) initSettingGroups
{
}

- (void) refreshSettingGroup
{
    [self initSettingGroups];
}

- (CrossSetting*) settingAtSection:(NSUInteger)section row:(NSInteger)row
{
    CrossSettingGroup * settingGroup = self.settingGroups[section];
    CrossSetting * setting = settingGroup.settings[row];
    return setting;
}

- (NSString*) stringForGroupInSection:(NSUInteger)section
{
    CrossSettingGroup * settingGroup = self.settingGroups[section];
    return settingGroup.title;
}

- (NSUInteger) numberOfSettingsInSection:(NSUInteger)section
{
    CrossSettingGroup *settingsGroup = [self.settingGroups objectAtIndex:section];
    return [settingsGroup.settings count];
}

- (void) cleanSettingGroup
{
    [self.settingGroups removeAllObjects];
}

@end
