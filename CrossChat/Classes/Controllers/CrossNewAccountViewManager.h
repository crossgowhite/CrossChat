//
//  CrossNewAccountManager.h
//  CrossChat
//
//  Created by chaobai on 15/9/22.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrossSetting.h"
#import "CrossSettingGroup.h"
#import "String.h"

@interface CrossNewAccountViewManager : NSObject

@property (nonatomic, strong) NSArray * settingGroups;


- (CrossSetting*) settingAtSection:(NSUInteger)section row:(NSInteger)row;

- (NSString*) stringForGroupInSection:(NSUInteger)section;

- (NSUInteger) numberOfSettingsInSection:(NSUInteger)section;

@end
