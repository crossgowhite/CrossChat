//
//  CrossViewSetting.h
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrossSetting.h"
@import UIKit;

@interface CrossViewSetting : CrossSetting

@property (nonatomic, retain, readonly) Class viewControllerClass;
@property (nonatomic) UITableViewCellAccessoryType accessoryType;

- (id) initWithTitle:(NSString*)newTitle description:(NSString*)newDescription viewControllerClass:(Class)newViewControllerClass;//animation:(SHOWDETAILCONTROLLERANIMATION) newAnimation

- (void) showView;

@end
