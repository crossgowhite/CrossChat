//
//  CrossSettingManager.h
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrossViewManager.h"

@interface CrossSettingViewManager : CrossViewManager

- (void) addSetting: (CrossSetting *)newSetting AtIndexPath:(NSIndexPath*)indexPath;

@end
