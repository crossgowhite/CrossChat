//
//  CrossTableViewDelegate.m
//  CrossChat
//
//  Created by chaobai on 15/11/16.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossTableViewDelegate.h"
#import "CrossViewManager.h"
#import "CrossSetting.h"

@interface CrossTableViewDelegate ()

@property (nonatomic, strong) CrossViewManager * viewManager;

@end

@implementation CrossTableViewDelegate

- (id)initWithViewManager:(CrossViewManager *)manager
{
    if (self = [super init]) {
        self.viewManager = manager;
    }
    return self;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CrossSetting *setting = [self.viewManager settingAtSection:indexPath.section row:indexPath.row];
    CrossSettingActionBlock actionBlock = setting.actionBlock;
    if (actionBlock)
    {
        actionBlock();
    }
}

@end
