//
//  CrossSettingManager.h
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrossCertificateSetting.h"
#import "String.h"
#import "CrossSettingGroup.h"

@interface CrossSettingViewManager : NSObject

@property (nonatomic, strong) NSArray * settingGroups;


- (CrossSetting*) settingAtIndexPath:(NSIndexPath*)indexPath;

- (NSString*) stringForGroupInSection:(NSUInteger)section;

- (NSUInteger) numberOfSettingsInSection:(NSUInteger)section;

- (NSIndexPath *) indexPathForSetting:(CrossSetting *)setting;

- (void) addSetting: (CrossSetting *)newSetting AtIndexPath:(NSIndexPath*)indexPath;
@end
