//
//  CrossBuddyViewManager.m
//  CrossChat
//
//  Created by chaobai on 15/10/29.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossBuddyViewManager.h"
#import "CrossSettingGroup.h"
#import "String.h"
#import "CrossBuddyManager.h"
#import "CrossBuddy.h"
#import "CrossBuddySetting.h"

@interface CrossBuddyViewManager ()

@end

@implementation CrossBuddyViewManager

- (id) init
{
    self = [super init];
    
    if(self)
    {
        [self initArrayGroups];
    }
    
    return self;
}

- (void) initArrayGroups
{
    //1. create basic group
    NSMutableArray * allGruops = [NSMutableArray array];
    
    //1. init add account gruop
    NSMutableArray * buddyArray = [NSMutableArray array];
    
    NSArray * buddyList = [[CrossBuddyManager sharedInstance]getAllBuddyList];
    
    for (CrossBuddy * buddy in buddyList) {
        CrossBuddySetting * setting = [[CrossBuddySetting alloc]initWithBuddy: buddy Title:buddy.displayName description:nil];
        [buddyArray addObject:setting];
    }
    
    if ([buddyArray count] > 0) {
        
        CrossSettingGroup * buddyGroup = [[CrossSettingGroup alloc]initWithTitle:BASIC_STRING settings:buddyArray];
        [allGruops addObject:buddyGroup];
    }
    
    self.arrayGroups = allGruops;
    
}

@end
