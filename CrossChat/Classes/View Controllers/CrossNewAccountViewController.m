//
//  CrossNewAccountViewController.m
//  CrossChat
//
//  Created by chaobai on 15/9/22.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossNewAccountViewController.h"
#import "String.h"
#import "CrossNewAccountViewManager.h"
#import "CrossAccountTableViewCell.h"
#import "CrossSettingTableViewCell.h"
#import "CrossAccount.h"
#import "CrossAlertAction.h"
#import "CrossAlertViewController.h"
#import "CrossProtocolManager.h"
#import "CrossProtocolStatus.h"
#import "CrossAccountDataBaseManager.h"
#import "CrossBuddyDataBaseManager.h"
#import "CrossConstants.h"


#import "MBProgressHUD.h"
#import "YAPDatabaseViewMappings.h"
#import "YapDatabase.h"
#import "YapDatabaseView.h"
#import "YAPDatabaseConnection.h"

@interface CrossNewAccountViewController ()


@property (weak, nonatomic) IBOutlet UITableView *      tableView;
@property (nonatomic, retain) CrossNewAccountViewManager *  accountManager;
@property (nonatomic, strong) CrossAccount           *  account;

//table cell
@property (nonatomic, strong) CrossAccountTableViewCell * userNameTableViewCell;
@property (nonatomic, strong) CrossAccountTableViewCell * passWordTableViewCell;
@property (nonatomic, strong) CrossAccountTableViewCell * autoLoginTbleViewCell;

//hud
@property (nonatomic, strong) MBProgressHUD * HUD;

@property (nonatomic, strong) MBProgressHUD * successHUD;
@end

@implementation CrossNewAccountViewController

- (id)initWithAccount :(CrossAccount *)newAccount
{
    self = [super init];
    if (self)
    {
        self.account = newAccount;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //1 add cancel left bar button item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:CANCEL_STRING style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    
    //2 add create right bar button item
    switch (self.action)
    {
        case CREATE_NEW_ACCOUNT_ACTION:
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:CREATE_STRING style:UIBarButtonItemStylePlain target:self action:@selector(newAccountloginExistedAccountPressed:)];
            self.navigationItem.rightBarButtonItem.tag = CREATE_NEW_ACCOUNT_ACTION;
            break;
        case LOGIN_EXISTED_ACCOUNT_ACTION:
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LOGIN_STRING style:UIBarButtonItemStylePlain target:self action:@selector(newAccountloginExistedAccountPressed:)];
            self.navigationItem.rightBarButtonItem.tag = LOGIN_EXISTED_ACCOUNT_ACTION;
            break;
        default:
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:CREATE_STRING style:UIBarButtonItemStylePlain target:self action:nil];
            self.navigationItem.rightBarButtonItem.tag = CREATE_NEW_ACCOUNT_ACTION;
            break;
    }
    
    //3 init new account manager
    self.accountManager = [[CrossNewAccountViewManager alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL) initAccount
{
    //hard code xmpp type account
    CrossAccount * account = [CrossAccount accountForAccountType:CrossAccountTypeXMPP];
    
    if(account)
    {
        account.userName = self.userNameTableViewCell.getTextFiledString;
        account.password = self.passWordTableViewCell.getTextFiledString;
        account.auotoLogin = self.autoLoginTbleViewCell.getAutoLogin;
        
        if(self.account)
        {
            account.uniqueId = self.account.uniqueId;
        }
        
        self.account = account;
        return YES;
    }
    
    return NO;
}

- (void) viewDidAppear:(BOOL)animated
{
    if (self.account)
    {
        [self.userNameTableViewCell setTextfieldWithValue:self.account.userName];
        [self.passWordTableViewCell setTextfieldWithValue: self.account.password];
        [self.autoLoginTbleViewCell setAutoLogin: self.account.auotoLogin];
    }
}


#pragma mark -- check fields wether empty
- (BOOL) checkFields
{
    BOOL fields = self.userNameTableViewCell.getTextFiledString.length && self.passWordTableViewCell.getTextFiledString.length;
    
    if(!fields)
    {
        CrossAlertAction * okAction = [[CrossAlertAction alloc]initWithTitle:OK_STRING actionBlock:nil];
        NSArray * actionArray = @[okAction];
        
        CrossAlertViewController * viewController = [CrossAlertViewController crossAlertViewControllerWithTitle: ERROR_STRING message: USER_PASS_BLANK_STRING preferredStyle: UIAlertControllerStyleAlert AlertActionArray:actionArray];
        
        [self presentViewController:viewController animated:YES completion:nil];
    }
    return fields;
}

#pragma mark -- bar button click responser
- (void) cancelPressed: (id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) newAccountloginExistedAccountPressed: (id) sender
{
    if (![self checkFields])
    {
        return;
    }
    
    if([self initAccount])
    {
        switch ([sender tag])
        {
            case CREATE_NEW_ACCOUNT_ACTION:
                [self registerAccount];
                break;
            case LOGIN_EXISTED_ACCOUNT_ACTION:
                [self loginAccount];
                break;
            default:
                break;
        }
    }
}


#pragma mark -- UITableView Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.accountManager.arrayGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.accountManager numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    
    //case account info group : show account & password field
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"CustomCellIdentifier";
        cell = (CrossAccountTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CrossAccountTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        
        //remeber to cell inorder to get the value
        if(indexPath.row == 0)
            self.userNameTableViewCell = (CrossAccountTableViewCell *)cell;
        else if (indexPath.row == 1)
            self.passWordTableViewCell = (CrossAccountTableViewCell *)cell;
        else if(indexPath.row == 2)
            self.autoLoginTbleViewCell = (CrossAccountTableViewCell *)cell;
    }
    
    //case server info group : show server address field
    else
    {
        static NSString *cellIdentifierNormal = @"CellNormal";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierNormal];
        if(cell == nil)
        {
            cell = [[CrossSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifierNormal];
        }
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    CrossSetting * setting = [self.accountManager itemAtSection:indexPath.section row:indexPath.row];
    [(CrossSettingTableViewCell*)cell setSetting:setting];
    return cell;
   
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.accountManager stringForGroupInSection:section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -- hide the keyboard while scroll
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}



#pragma mark -- add notification center observe for login or ceate new account
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRegisterFailed:) name:CrossProtocolRegisterFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRegisterSuccess:) name:CrossProtocolRegisterSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSucess:) name:CrossProtocolLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginFailed:) name:CrossProtocolLoginFailed object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CrossProtocolRegisterFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CrossProtocolRegisterSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CrossProtocolLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CrossProtocolLoginFailed object:nil];
}


- (void)onRegisterSuccess: (NSNotification *)notification
{
    [self hideHUD];
    [self loginAccount];
    NSLog(@"CrossNewAccountViewController onRegisterSuccess");
}


- (void) onRegisterFailed: (NSNotification *)notification
{
    [self hideHUD];
    NSLog(@"CrossNewAccountViewController onRegisterFailed");
}


- (void)onLoginSucess:(NSNotification *)notification
{
    [self persistenceAccount];
    [self hideHUD];
    [self showSuccessHUD];
     NSLog(@"CrossNewAccountViewController onLoginSucess");
}

- (void)onLoginFailed:(NSNotification *)notification
{
    [self hideHUD];
    NSLog(@"CrossNewAccountViewController onLoginFailed");
}

- (void)onLogouted:(NSNotification*)notification
{
    [self dimissSelfView];
    NSLog(@"CrossNewAccountViewController onLogouted");
}
#pragma mark -- show & hide hud

//import note: hide process must do in the UI thread

- (void) showHUDWithText: (NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view endEditing:YES];
        if (!self.HUD)
        {
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.HUD];
        }
        self.HUD.mode = MBProgressHUDModeIndeterminate;
        self.HUD.labelText = text;
        self.HUD.dimBackground = YES;
        [self.HUD show:YES];

        });
}

- (void) hideHUD
{
    if(self.HUD)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"CrossNewAccountViewController hideHUD");
            [self.HUD removeFromSuperview];
            self.HUD = nil;
        });
    }
}

- (void) showSuccessHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view endEditing:YES];
        if (!self.successHUD)
        {
            self.successHUD = [[MBProgressHUD alloc] initWithView:self.view];
            self.successHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
            [self.view addSubview:self.successHUD];
        }
        self.successHUD.mode = MBProgressHUDModeCustomView;
        self.successHUD.labelText = SUCCESS_STRING;
        [self.successHUD show:YES];
        [self.successHUD hide:YES afterDelay:1];
        [self performSelector:@selector(dimissSelfView) withObject:nil afterDelay:1];
    });
}

#pragma mark -- login or register or logout

- (void) loginAccount
{
    id <CrossProtocol> protocol = [[CrossProtocolManager sharedInstance]protocolForAccount:self.account];
    
    if (protocol && self.account)
    {
        NSLog(@"LOGING");
        [self showHUDWithText:LOGINING_STRING];
        [protocol login];
    }
}

- (void) registerAccount
{
    id <CrossProtocol> protocol = [[CrossProtocolManager sharedInstance]protocolForAccount:self.account];
    
    if (protocol && self.account)
    {
        [self showHUDWithText:CREATEING_NEW_ACCOUNT_STRING];
        [protocol registerAccount];
    }
    
}


#pragma mark -- Yap database operation

//persistence account into sql db
- (void) persistenceAccount
{
    //1. save account info into account database
    [[CrossAccountDataBaseManager sharedInstance].readWriteDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [self.account saveWithTransaction:transaction];
    }];
}


#pragma mark -- dismiss self
- (void) dimissSelfView
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
