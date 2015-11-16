//
//  CrossBuddyTableViewController.m
//  CrossChat
//
//  Created by chaobai on 15/10/26.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossBuddyTableViewController.h"
#import "String.h"
#import "CrossProtocolManager.h"
#import "CrossBuddy.h"

#import "YAPDatabaseViewMappings.h"
#import "YapDatabase.h"
#import "YapDatabaseView.h"
#import "YAPDatabaseConnection.h"

#import "CrossDataBaseView.h"
#import "CrossBuddyDataBaseManager.h"
#import "CrossBuddyManager.h"

#import "CrossBuddyViewManager.h"
#import "CrossBuddySetting.h"

#import "CrossBuddyTableViewCell.h"
#import "CrossMessageViewController.h"


#import "CrossMessageManager.h"
#import "CrossMessageDataBaseManager.h"
#import "CrossMessage.h"
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
    if([CrossProtocolManager sharedInstance].numberOfConnectedAccount)
    {
        [self refreshTableView];
    }
    else
    {
        [self cleanTableView];
    }
    
    [[CrossProtocolManager sharedInstance] addObserver:self forKeyPath:NSStringFromSelector(@selector(numberOfConnectedAccount)) options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[CrossProtocolManager sharedInstance] removeObserver:self forKeyPath:NSStringFromSelector(@selector(numberOfConnectedAccount))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSUInteger numberConnectedAccounts = [[change objectForKey:NSKeyValueChangeNewKey] unsignedIntegerValue];
    //alredy connected
    if (numberConnectedAccounts)
    {
        [self refreshTableView];
    }
    
    else
    {
        [self cleanTableView];
    }
}

- (void)refreshTableView
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.buddyViewManager refreshSettingGroup];
        [self.tableView reloadData];
    });
}

- (void)cleanTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.buddyViewManager cleanSettingGroup];
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
