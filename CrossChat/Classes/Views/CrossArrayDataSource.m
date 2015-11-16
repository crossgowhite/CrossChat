//
//  CrossArrayDataSource.m
//  CrossChat
//
//  Created by chaobai on 15/11/16.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossArrayDataSource.h"
#import "CrossViewManager.h"

@interface CrossArrayDataSource ()

@property (nonatomic, copy) NSString * cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@property (nonatomic, strong) CrossViewManager * viewManager;
@property (nonatomic, retain, readonly) Class cellClass;
@end

@implementation CrossArrayDataSource

- (id)initWithViewManager:(CrossViewManager *)manager cellIdentifier:(NSString *)aCellIdentifier configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock cellClass:(Class)cellClass
{
    self = [super init];
    if (self)
    {
        self.viewManager = manager;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
        _cellClass = cellClass;
    }
    return self;
}

#pragma mark -- UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewManager.settingGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewManager numberOfSettingsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[self.cellClass alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:self.cellIdentifier];
    }
    
    id item = [self.viewManager settingAtSection:indexPath.section row:indexPath.row];
    self.configureCellBlock(cell, item);
    return cell;
}
@end
