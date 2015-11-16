//
//  CrossViewManager.h
//  CrossChat
//
//  Created by chaobai on 15/11/16.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CrossSetting;

@interface CrossViewManager : NSObject

@property (nonatomic, strong) NSMutableArray * settingGroups;

- (void) refreshSettingGroup;

- (void) cleanSettingGroup;

- (CrossSetting*) settingAtSection:(NSUInteger)section row:(NSInteger)row;

- (NSString*) stringForGroupInSection:(NSUInteger)section;

- (NSUInteger) numberOfSettingsInSection:(NSUInteger)section;

@end
