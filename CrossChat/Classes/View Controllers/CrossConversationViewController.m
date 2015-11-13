//
//  CrossConversationViewController.m
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossConversationViewController.h"
#import "String.h"
#import "CrossSettingViewController.h"
#import "CrossProtocolManager.h"
#import "CrossAccount.h"
#import "CrossAccountManager.h"
#import "CrossConversationViewManager.h"

#import "CrossXMPPMessageStatus.h"
#import "CrossConversationTableViewCell.h"
#import "CrossConversationSetting.h"

#import "XMPPMessage.h"
#import "CrossMessageViewController.h"
#import "CrossXMPPMessageDecoder.h"

#import "CrossBuddyDataBaseManager.h"
#import "CrossMessageManager.h"
#import "CrossMessage.h"
#import "CrossMessageDataBaseManager.h"

#import "CrossMessageViewController.h"


@interface CrossConversationViewController () <CrossSettingDelegate>

@property (nonatomic, strong) UIBarButtonItem * settingBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem * composeBarButtonItem;

@property (nonatomic, strong) CrossConversationViewManager * conversationViewManager;

@end

@implementation CrossConversationViewController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:CrossXMPPMessageReceived object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = CHATS_STRING;
    
    
    //1. init navigation bar item
    self.settingBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"SettingsIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(settingBarButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = self.settingBarButtonItem;
    
    //2. init compose bar item
    self.composeBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = self.composeBarButtonItem;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    self.conversationViewManager = [[CrossConversationViewManager alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.conversationViewManager.settingGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
     return [self.conversationViewManager numberOfSettingsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"BuddyCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[CrossConversationTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    CrossSetting * setting = [self.conversationViewManager settingAtSection:indexPath.section row:indexPath.row];
    setting.delegate = self;
    [(CrossConversationTableViewCell*)cell setSetting:setting];
    return  cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CrossSetting *setting = [self.conversationViewManager settingAtSection:indexPath.section row:indexPath.row];
    CrossSettingActionBlock actionBlock = setting.actionBlock;
    if (actionBlock)
    {
        actionBlock();
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    if([CrossProtocolManager sharedInstance].numberOfConnectedAccount)
    {
        [self enableComposeButton];
    }
    else
    {
        [self disableComposeButton];
        [self cleanTableView];
    }
    
    [self refreshTableView];
    [[CrossProtocolManager sharedInstance] addObserver:self forKeyPath:NSStringFromSelector(@selector(numberOfConnectedAccount)) options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[CrossProtocolManager sharedInstance] removeObserver:self forKeyPath:NSStringFromSelector(@selector(numberOfConnectedAccount))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSUInteger numberConnectedAccounts = [[change objectForKey:NSKeyValueChangeNewKey] unsignedIntegerValue];
    if (numberConnectedAccounts)
    {
        [self enableComposeButton];
        [self refreshTableView];
    }
    else
    {
        [self disableComposeButton];
        [self cleanTableView];
    }
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
        [self.conversationViewManager refreshSettingGroup];
        [self.tableView reloadData];
    });
}

- (void)cleanTableView
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationViewManager cleanSettingGroup];
        [self.tableView reloadData];
    });
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CrossXMPPMessageReceived object:nil];
}


#pragma mark -- On received xmpp message
- (void)didReceiveMessage:(NSNotification*)notification
{
    XMPPMessage * message = notification.object;
    
    //if crossmessageview controller is in show
    //do not handle message received
    if (![self.navigationController.viewControllers.lastObject isKindOfClass:[CrossMessageViewController class]])
    {
        NSString * messageText = [CrossXMPPMessageDecoder getMessageTextWithMessage:message];
        if (messageText)
        {
            NSString * fromUser = [CrossXMPPMessageDecoder getFromUserNameWithMessage:message];
            CrossBuddy * buddy = [[CrossBuddyDataBaseManager sharedInstance]getCrossBuddyByName:fromUser];
            if (buddy)
            {
                buddy.statusMessage = messageText;
                [[CrossBuddyDataBaseManager sharedInstance].readWriteDatabaseConnection
                 asyncReadWriteWithBlock: ^(YapDatabaseReadWriteTransaction *transaction)
                 {
                     [buddy saveWithTransaction:transaction];
                 }
                 completionBlock:^
                 {
                     [self refreshTableView];
                     [self persistenceMessageText:messageText Buddy:buddy];
                 }];
            }
        }
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

- (void) persistenceMessageText:(NSString*)messageText Buddy:(CrossBuddy*)buddy
{
    CrossMessageDataBaseManager * messageDataBaseManager =  [[CrossMessageManager sharedInstance] databaseManagerForBuddy:buddy];
    CrossMessage * message = [CrossMessage CrossMessageWithText:messageText read:[NSNumber numberWithInteger:1] incoming:[NSNumber numberWithInteger:1] owner:buddy.userName];
    [messageDataBaseManager persistenceMessage:message completeBlock:nil];
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
