//
//  CrossConversationViewController.m
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossConversationViewController.h"
#import "String.h"
#import "CrossConstants.h"
#import "CrossSettingViewController.h"

#import "CrossConversationViewManager.h"

#import "CrossConversationTableViewCell.h"
#import "CrossConversationSetting.h"

#import "CrossChatService.h"
#import "CrossMessage.h"

#import "CrossMessageViewController.h"
#import "CrossArrayDataSource.h"
#import "CrossTableViewDelegate.h"

static NSString * ConversationCellIdentifier = @"ConversationCell";

@interface CrossConversationViewController () <CrossSettingDelegate>

@property (nonatomic, strong) UIBarButtonItem * settingBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem * composeBarButtonItem;

@property (nonatomic, strong) CrossViewManager * conversationViewManager;

@property (nonatomic, strong) CrossArrayDataSource * conversationArrayDataSource;
@property (nonatomic, strong) CrossTableViewDelegate * tableViewDelegate;
@end

@implementation CrossConversationViewController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:CrossMessageReceived object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = CHATS_STRING;
    
    self.conversationViewManager = [[CrossConversationViewManager alloc]init];
    
    //1. init navigation bar item
    self.settingBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"SettingsIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(settingBarButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = self.settingBarButtonItem;
    
    //2. init compose bar item
    self.composeBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = self.composeBarButtonItem;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    //4. init data source
    TableViewCellConfigureBlock configureCell = ^(CrossConversationTableViewCell *cell, CrossSetting *setting) {
        setting.delegate = self;
        [cell setSetting:setting];
    };
    self.conversationArrayDataSource = [[CrossArrayDataSource alloc]initWithViewManager:self.conversationViewManager cellIdentifier:ConversationCellIdentifier configureCellBlock:configureCell cellClass:[CrossConversationTableViewCell class]];
    self.tableView.dataSource = self.conversationArrayDataSource;
    
    
    //5. init delegate
    self.tableViewDelegate = [[CrossTableViewDelegate alloc]initWithViewManager:self.conversationViewManager];
    self.tableView.delegate = self.tableViewDelegate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -- setting bar buttom click
- (void)settingBarButtonItemPressed:(id)sender
{
    //1. create setting view controller
    CrossSettingViewController * settingViewController = [[CrossSettingViewController alloc]init];
    [settingViewController setHidesBottomBarWhenPushed:YES];
    //2. push setting view controller into navigation controller
    [self.navigationController pushViewController:settingViewController animated:YES];
}

#pragma mark -- compose bar buttom click
- (void)composeBarButtonItemPressed:(id)sender
{
//    CrossContactViewController * contactViewController = [[CrossContactViewController alloc]init];
//    [self.navigationController pushViewController:contactViewController animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if([[CrossChatService sharedInstance] getAccountConnectionStatus] == CrossProtocolConnectionStatusConnected)
        [self enableComposeButton];
    else
        [self disableComposeButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSucess:) name:CrossProtocolLoginSuccess object:nil];
    [self refreshTableView];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CrossProtocolLoginSuccess object:nil];
    [super viewDidDisappear:animated];
}

- (void)onLoginSucess:(NSNotification *)notification
{
    //3. init conversation view manager
    [self enableComposeButton];
    [self refreshTableView];
}


- (void)enableComposeButton
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.composeBarButtonItem.enabled = YES;
    });
}

- (void)disableComposeButton
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.composeBarButtonItem.enabled = NO;
    });
}

- (void)refreshTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationViewManager refreshArrayGroup];
        [self.tableView reloadData];
    });
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CrossMessageReceived object:nil];
}


#pragma mark -- On received xmpp message
- (void)didReceiveMessage:(NSNotification*)notification
{
    if (![self.navigationController.viewControllers.lastObject isKindOfClass:[CrossMessageViewController class]])
    {
        [self refreshTableView];
    }
}


#pragma mark -- action block call back function item
- (void) Setting:(CrossSetting*)setting showDetailViewControllerClass:(Class)viewControllerClass
{
    //show message view controller
    if ([setting isKindOfClass:[CrossConversationSetting class]])
    {
        CrossMessageViewController *viewController = [[viewControllerClass alloc] init];
        CrossConversationSetting * conversationSetting = (CrossConversationSetting*)setting;
        viewController.buddy = conversationSetting.buddy;
        
        [viewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


@end
