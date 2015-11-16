//
//  CrossConversationManager.m
//  CrossChat
//
//  Created by chaobai on 15/11/6.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossConversationViewManager.h"
#import "CrossConversationSetting.h"
#import "CrossSettingGroup.h"
#import "CrossBuddyManager.h"
#import "String.h"

@implementation CrossConversationViewManager

- (id) init
{
    self = [super init];
    
    if(self)
    {
        //[self initSettingGroups];
    }
    
    return self;
}

- (void) initSettingGroups
{
    //1. create basic group
    NSMutableArray * allGruops = [NSMutableArray array];
    
    //1. init add account gruop
    NSMutableArray * buddyArray = [NSMutableArray array];
    
    NSArray * buddyList = [[CrossBuddyManager sharedInstance] getInConversationBuddyList];
    
    for (CrossBuddy * buddy in buddyList) {
        CrossConversationSetting * setting = [[CrossConversationSetting alloc]initWithBuddy: buddy Title:buddy.displayName description:nil];
        [buddyArray addObject:setting];
    }
    
    if ([buddyArray count] > 0) {
        
        CrossSettingGroup * buddyGroup = [[CrossSettingGroup alloc]initWithTitle:BASIC_STRING settings:buddyArray];
        [allGruops addObject:buddyGroup];
    }
    
    
    self.settingGroups = allGruops;
    
}

@end
