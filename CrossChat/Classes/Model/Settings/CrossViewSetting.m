//
//  CrossViewSetting.m
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossViewSetting.h"

@implementation CrossViewSetting

- (id) initWithTitle:(NSString*)newTitle description:(NSString*)newDescription viewControllerClass:(Class)newViewControllerClass //animation:(SHOWDETAILCONTROLLERANIMATION)
{
    if(self = [super initWithTitle:newTitle description:newDescription])
    {
//        self.animation = newAnimation;
        self.accessoryType = UITableViewCellAccessoryNone;
        _viewControllerClass = newViewControllerClass;
        __weak typeof(self) weakSelf = self;
        self.actionBlock = ^ {
            [weakSelf showView];
        };
    }
    return self;
}

- (void) showView
{
    [self.delegate Setting:self showDetailViewControllerClass:self.viewControllerClass];
}


@end
