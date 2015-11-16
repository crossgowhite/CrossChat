//
//  CrossNewAccountManager.m
//  CrossChat
//
//  Created by chaobai on 15/9/22.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossNewAccountViewManager.h"
#import "CrossSetting.h"
#import "CrossSettingGroup.h"
#import "String.h"

@implementation CrossNewAccountViewManager

- (id) init
{
    self = [super init];
    
    if(self)
    {
        [self initSettingGroups];
    }
    
    return self;
}

- (void) initSettingGroups
{
    //1. create basic group
    NSMutableArray * allGruops = [NSMutableArray array];
    
    //1. init add account gruop
    NSMutableArray * basicArray = [NSMutableArray array];
    CrossSetting * userName = [[CrossSetting alloc]initWithTitle:ACCOUNTS_STRING description:nil];
    CrossSetting * passWord = [[CrossSetting alloc]initWithTitle:PASSWORD_STRING description:nil];
    
    
    CrossSetting * autologin = [[CrossSetting alloc]initWithTitle:AUTO_LOGIN_STRING description:nil];
    [basicArray addObject:userName];
    [basicArray addObject:passWord];
    [basicArray addObject:autologin];
    
    CrossSettingGroup * basicGroup = [[CrossSettingGroup alloc]initWithTitle:BASIC_STRING settings:basicArray];
    
    [allGruops addObject:basicGroup];
    
    
    //2. init server group
    NSMutableArray * serverArray = [NSMutableArray array];
    CrossSetting * server = [[CrossSetting alloc]initWithTitle:XMMPP_SERVER_ADDRESS_STRING description:XMPP_SERVER_ADDRESS_STRING];
    [serverArray addObject:server];
    
    CrossSettingGroup * serverGroup = [[CrossSettingGroup alloc]initWithTitle:SERVER_STRING settings:serverArray];
    [allGruops addObject:serverGroup];
    
    self.settingGroups = allGruops;
    
}


@end
