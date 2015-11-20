//
//  CrossBuddyTableViewController.m
//  CrossChat
//
//  Created by chaobai on 15/10/26.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossBuddyTableViewController.h"
#import "String.h"

#import "CrossBuddyViewManager.h"
#import "CrossBuddySetting.h"

#import "CrossBuddyTableViewCell.h"
#import "CrossMessageViewController.h"

#import "CrossArrayDataSource.h"
#import "CrossTableViewDelegate.h"

static NSString * BuddyCellIdentifier = @"BuddyCell";

@interface CrossBuddyTableViewController () <CrossSettingDelegate>

@property (nonatomic, strong) CrossViewManager * buddyViewManager;
@property (nonatomic, strong) CrossArrayDataSource * buddyArrayDataSource;
@property (nonatomic, strong) CrossTableViewDelegate * tableViewDelegate;

@end

@implementation CrossBuddyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = BUDDY_STRING;
    self.buddyViewManager = [[CrossBuddyViewManager alloc]init];
    
    
    TableViewCellConfigureBlock configureCell = ^(CrossBuddyTableViewCell *cell, CrossSetting *setting) {
        setting.delegate = self;
        [cell setSetting:setting];
    };
    self.buddyArrayDataSource = [[CrossArrayDataSource alloc]initWithViewManager:self.buddyViewManager cellIdentifier:BuddyCellIdentifier configureCellBlock:configureCell cellClass:[CrossBuddyTableViewCell class]];
    self.tableView.dataSource = self.buddyArrayDataSource;
    
    self.tableViewDelegate = [[CrossTableViewDelegate alloc]initWithViewManager:self.buddyViewManager];
    self.tableView.delegate = self.tableViewDelegate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- connection status kvo
- (void)viewWillAppear:(BOOL)animated
{
    [self refreshTableView];
}

- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)refreshTableView
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.buddyViewManager refreshArrayGroup];
        [self.tableView reloadData];
    });
}

#pragma mark -- action block call back function item
- (void) Setting:(CrossSetting*)setting showDetailViewControllerClass:(Class)viewControllerClass
{
    //show message view controller
    if ([setting isKindOfClass:[CrossBuddySetting class]])
    {
        CrossMessageViewController *viewController = [[viewControllerClass alloc] init];
        CrossBuddySetting * buddySetting = (CrossBuddySetting*)setting;
        viewController.buddy = buddySetting.buddy;
        [viewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
