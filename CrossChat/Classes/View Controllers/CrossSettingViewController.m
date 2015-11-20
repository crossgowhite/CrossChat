//
//  CrossSettingViewController.m
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossSettingViewController.h"
#import "String.h"
#import "CrossSettingViewManager.h"
#import "CrossSettingTableViewCell.h"
#import "CrossNewAccountSetting.h"
#import "CrossAlertViewController.h"
#import "CrossNewAccountViewController.h"
#import "CrossAlertAction.h"
#import "CrossCertificateDomainViewController.h"

#import "CrossCertificateSetting.h"

#import "CrossAccountSetting.h"

#import "CrossDataBaseView.h"
#import "CrossAccountDataBaseManager.h"

#import "CrossProtocolManager.h"
#import "CrossProtocolStatus.h"

#import "CrossChatService.h"

#import "YAPDatabaseViewMappings.h"
#import "YapDatabase.h"
#import "YapDatabaseView.h"
#import "YAPDatabaseConnection.h"

@interface CrossSettingViewController () <CrossSettingDelegate>

@property (nonatomic, retain) CrossSettingViewManager *settingsManager;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//yap
@property (nonatomic, strong) YapDatabaseConnection * databaseConnection;
@property (nonatomic, strong) YapDatabaseViewMappings * mappings;

@end

@implementation CrossSettingViewController


- (id) init
{
    if(self = [super init])
    {
        self.title = SETTINGS_STRING;
        self.settingsManager = [[CrossSettingViewManager alloc]init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //mare sure all acount view is registered in yap
    [CrossDataBaseView registerAllAccountsDatabaseView];
    
    //yap data base part
    self.databaseConnection = [[CrossChatService sharedInstance].accountDataBaseManager newConnection];
    [self.databaseConnection beginLongLivedReadTransaction];
    
    
    //Create mappings from allAccountsDatabaseView
    self.mappings = [[YapDatabaseViewMappings alloc] initWithGroups:@[CrossAllAccountGroup] view:CrossAllAccountDatabaseViewExtensionName];
    
    [self.databaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction){
        [self.mappings updateWithTransaction:transaction];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yapDatabaseModified:)
                                                 name:YapDatabaseModifiedNotification
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.settingsManager.arrayGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return [self.mappings numberOfItemsInSection:0] + 1;
        //return [self.mappings numberOfItemsInSection:0] + [self.settingsManager numberOfSettingsInSection:section];
    
    return [self.settingsManager numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SettingCell";
    
    CrossSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    CrossSetting * setting = nil;
    
    if(cell == nil)
    {
        cell = [[CrossSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0 && indexPath.row != 0)
    {
        NSIndexPath * qureyindex = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
        CrossAccount * account = [self accountAtIndexPath:qureyindex];
        
        CrossProtocolConnectionStatus  connectstatus = CrossProtocolConnectionStatusDisconnected;
        if ([[CrossProtocolManager sharedInstance] existsProtocolForAccount:account])
        {
            id <CrossProtocol> protocol = [[CrossProtocolManager sharedInstance] protocolForAccount:account];
            if (protocol)
            {
                connectstatus = [protocol getProtocolConnectionStatus];
            }
        }
        
        CrossAccountSetting * accountsetting = [[CrossAccountSetting alloc]initWithTitle:account.userName description:[self getConnectionStatus:connectstatus]];
        accountsetting.account = account;
        setting = accountsetting;
        [self.settingsManager addSetting:setting AtIndexPath:indexPath];
    }
    
    else
    {
        setting = [self.settingsManager itemAtSection:indexPath.section row:indexPath.row];
//        setting = [self.settingsManager settingAtIndexPath:indexPath];
    }
    
    setting.delegate = self;
    [cell setSetting:setting];
    return  cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.settingsManager stringForGroupInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CrossSetting *setting = [self.settingsManager itemAtSection:indexPath.section row:indexPath.row];
    CrossSettingActionBlock actionBlock = setting.actionBlock;
    if (actionBlock)
    {
        actionBlock();
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -- CrossSettingDelegate
- (void) refreshView
{
    
}

//action block call back function item
- (void) Setting:(CrossSetting*)setting showDetailViewControllerClass:(Class)viewControllerClass
{
    //Case Certificate setting Item
    if ([setting isKindOfClass:[CrossCertificateSetting class]])
    {
        UIViewController *viewController = [[viewControllerClass alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    //Case New account alert setting Item
    else if ([setting isKindOfClass:[CrossNewAccountSetting class]])
    {
        void (^createAccountBlock)(void) = ^void(void) {
            [self createAccount];
        };
        
        void (^connectAccountBlock)(void) = ^void(void) {
            [self connectAccount];
        };
        
        CrossAlertAction * createAccountAction = [[CrossAlertAction alloc]initWithTitle:CREATE_NEW_ACCOUNT_STRING actionBlock:createAccountBlock];
        CrossAlertAction * connectAccountAction = [[CrossAlertAction alloc]initWithTitle:CONNECT_EXISTING_STRING actionBlock:connectAccountBlock];
        CrossAlertAction * cancelAction = [[CrossAlertAction alloc]initWithTitle:CANCEL_STRING actionBlock:nil];
        NSArray * actionArray = @[createAccountAction,connectAccountAction,cancelAction];
        CrossAlertViewController * viewController = [viewControllerClass crossAlertViewControllerWithTitle: NEW_ACCOUNTS_STRING message: nil preferredStyle: UIAlertControllerStyleActionSheet AlertActionArray:actionArray];
        
        [self presentViewController:viewController animated:YES completion:nil];
    }
    
    //Case detail account
    else if ([setting isKindOfClass:[CrossAccountSetting class]])
    {
        CrossAccountSetting * accountsetting = setting;
        CrossProtocolConnectionStatus connectstatus = CrossProtocolConnectionStatusDisconnected;
        if ([[CrossProtocolManager sharedInstance] existsProtocolForAccount:accountsetting.account])
        {
            id <CrossProtocol> protocol = [[CrossProtocolManager sharedInstance] protocolForAccount:accountsetting.account];
            if (protocol)
            {
                 connectstatus = [protocol getProtocolConnectionStatus];
            }
        }
        
        if (connectstatus == CrossProtocolConnectionStatusDisconnected)
            [self connectAccountWithExsitedAccount:accountsetting.account];
        
        else
        {
            void (^logoutAccountBlock)(void) = ^void(void) {
                [self logoutAccount:accountsetting.account];
            };
            
            CrossAlertAction * logoutAccountAction = [[CrossAlertAction alloc]initWithTitle:LOGOUT_STRING actionBlock:logoutAccountBlock];
            CrossAlertAction * cancelAction = [[CrossAlertAction alloc]initWithTitle:CANCEL_STRING actionBlock:nil];
            NSArray * actionArray = @[logoutAccountAction,cancelAction];
            CrossAlertViewController * viewController = [CrossAlertViewController crossAlertViewControllerWithTitle: LOGOUT_STRING message: nil preferredStyle: UIAlertControllerStyleActionSheet AlertActionArray:actionArray];
            
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
}

- (void) createAccount
{
    CrossNewAccountViewController * newAccount = [[CrossNewAccountViewController alloc] init];
    newAccount.action = CREATE_NEW_ACCOUNT_ACTION;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:newAccount];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) connectAccount
{
    CrossNewAccountViewController * connectAccount = [[CrossNewAccountViewController alloc] init];
    connectAccount.action = LOGIN_EXISTED_ACCOUNT_ACTION;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:connectAccount];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) connectAccountWithExsitedAccount : (CrossAccount *)newAccount
{
    CrossNewAccountViewController * connectAccount = [[CrossNewAccountViewController alloc] initWithAccount:newAccount];
    connectAccount.action = LOGIN_EXISTED_ACCOUNT_ACTION;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:connectAccount];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void) logoutAccount : (CrossAccount *)newAccount
{
    id <CrossProtocol> protocol = [[CrossProtocolManager sharedInstance]protocolForAccount:newAccount];
    
    if (protocol && newAccount)
    {
        if ([protocol getProtocolConnectionStatus] == CrossProtocolConnectionStatusConnected)
        {
            [protocol disconnect];
        }
    }
}


#pragma mark - yap data base change

- (void) yapDatabaseModified: (NSNotification *)notification
{
    // Jump to the most recent commit.
    // End & Re-Begin the long-lived transaction atomically.
    // Also grab all the notifications for all the commits that I jump.
    // If the UI is a bit backed up, I may jump multiple commits.
    
    NSArray *notifications = [self.databaseConnection beginLongLivedReadTransaction];
    
    // Process the notification(s),
    // and get the change-set(s) as applies to my view and mappings configuration.
    
    NSArray *sectionChanges = nil;
    NSArray *rowChanges = nil;
    
    
    [ [self.databaseConnection ext:CrossAllAccountDatabaseViewExtensionName] getSectionChanges:&sectionChanges
                                                                                    rowChanges:&rowChanges
                                                                              forNotifications:notifications
                                                                                  withMappings:self.mappings];
    // No need to update mappings.
    // The above method did it automatically.
    
    if ([sectionChanges count] == 0 & [rowChanges count] == 0)
    {
        // Nothing has changed that affects our tableView
        return;
    }
    
    // Familiar with NSFetchedResultsController?
    // Then this should look pretty familiar
    
    [self.tableView beginUpdates];
    
    for (YapDatabaseViewSectionChange *sectionChange in sectionChanges)
    {
        switch (sectionChange.type)
        {
            case YapDatabaseViewChangeDelete :
            {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionChange.index]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
            case YapDatabaseViewChangeInsert :
            {
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionChange.index]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
        }
    }
    
    for (YapDatabaseViewRowChange *rowChange in rowChanges)
    {
        NSIndexPath * actionindex = [NSIndexPath indexPathForRow:rowChange.newIndexPath.row+1 inSection:rowChange.newIndexPath.section];
        
        switch (rowChange.type)
        {
            case YapDatabaseViewChangeDelete :
            {
                [self.tableView deleteRowsAtIndexPaths:@[ actionindex ]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
            case YapDatabaseViewChangeInsert :
            {
                [self.tableView insertRowsAtIndexPaths:@[ actionindex ]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
            case YapDatabaseViewChangeMove :
            {
                [self.tableView deleteRowsAtIndexPaths:@[ actionindex ]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView insertRowsAtIndexPaths:@[ actionindex ]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
            case YapDatabaseViewChangeUpdate :
            {
                [self.tableView reloadRowsAtIndexPaths:@[ actionindex ]
                                      withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    }
    
    [self.tableView endUpdates];
}

- (CrossAccount *) accountAtIndexPath: (NSIndexPath *)indexPath
{
    __block CrossAccount *account = nil;
    [self.databaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        
        account = [[transaction extension:CrossAllAccountDatabaseViewExtensionName] objectAtIndexPath:indexPath withMappings:self.mappings];
    }];
    
    return account;
}

- (NSString *) getConnectionStatus: (CrossProtocolConnectionStatus)status
{
    if (status == CrossProtocolConnectionStatusDisconnected)
        return DISCONNECT_STRING;
    
    else if (status == CrossProtocolConnectionStatusConnected)
        return CONNECTED_STRING;
    
    else if (status == CrossProtocolConnectionStatusConnecting)
        return CONNECTING_STRING;
    
    return DISCONNECT_STRING;
}


- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAccountTableView:) name:CrossProtocolLogouted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSucess:) name:CrossProtocolLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginFailed:) name:CrossProtocolLoginFailed object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CrossProtocolLogouted object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CrossProtocolLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CrossProtocolLoginFailed object:nil];
}

- (void)refreshAccountTableView:(NSNotification*)notification
{
     dispatch_async(dispatch_get_main_queue(), ^{
         [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
     });
}

- (void)onLoginSucess:(NSNotification *)notification
{
    [self refreshAccountTableView:nil];
}

- (void)onLoginFailed:(NSNotification *)notification
{
    [self refreshAccountTableView:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
