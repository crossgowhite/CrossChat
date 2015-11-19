//
//  CrossChatService.m
//  CrossChat
//
//  Created by chaobai on 15/11/19.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossChatService.h"
#import "CrossAccount.h"
#import "CrossProtocolManager.h"
#import "CrossAccountDataBaseManager.h"
#import "CrossConstants.h"


#import "MBProgressHUD.h"

static CrossChatService * sharedService = nil;

@interface CrossChatService ()

@property (retain, nonatomic) CrossAccount * account;

@end


@implementation CrossChatService

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.account = nil;
        
        [self initNotification];
        //setup database
        [[CrossAccountDataBaseManager sharedInstance] setupDataBaseWithName :CrossYapDatabaseName];
        
        //auto login
        [self autoLogin];
    }
    
    return self;
}

+ (CrossChatService*)sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        sharedService = [[super allocWithZone:NULL] init];
    });
    return sharedService;
}


// Get service relate account
- (CrossAccount *)getServiceAccount
{
    return self.account;
}

// Login Action
- (BOOL)loginWithAccount:(CrossAccount*)account
{
    if (account)
    {
        id <CrossProtocol> protocol = [[CrossProtocolManager sharedInstance] protocolForAccount:account];
        if (protocol)
        {
            self.account = account;
            [protocol login];
            [self showHUD];
            return YES;
        }
    }
    return NO;
}

//disconnect Action
- (void)disconnect
{
    if (self.account)
    {
        id <CrossProtocol> protocol = [[CrossProtocolManager sharedInstance] protocolForAccount:self.account];
        if (protocol)
            [protocol disconnect];
    }
}

//register account
- (BOOL)registerWithAccount:(CrossAccount*)account
{
    if ([self getAccountConnectionStatus] != CrossProtocolConnectionStatusDisconnected)
    {
        id <CrossProtocol> protocol = [[CrossProtocolManager sharedInstance] protocolForAccount:account];
        if (protocol)
        {
            [protocol disconnect];
        }
    }
    
    if (account)
    {
        id <CrossProtocol> protocol = [[CrossProtocolManager sharedInstance] protocolForAccount:account];
        if (protocol)
        {
            self.account = account;
            [protocol registerAccount];
            [self showHUD];
            return YES;
        }
    }
    
    return NO;
}

//about connection status
- (CrossProtocolConnectionStatus)getAccountConnectionStatus
{
    if (self.account)
    {
        id <CrossProtocol> protocol = [[CrossProtocolManager sharedInstance] protocolForAccount:self.account];
        if (protocol)
        {
            return [protocol getProtocolConnectionStatus];
        }
    }
    return CrossProtocolConnectionStatusDisconnected;
}

//about message
- (void)sendMessage:(CrossMessage *)newMessage
{
    if (self.account && [self getAccountConnectionStatus] == CrossProtocolConnectionStatusConnected)
    {
        id <CrossProtocol> protocol = [[CrossProtocolManager sharedInstance] protocolForAccount:self.account];
        if (protocol)
        {
            [protocol sendMessage:newMessage];
        }
    }
}

//persistence Account
- (void)persistenceAccount:(CrossAccount*)account
{
    if (account)
    {
        self.account = account;
        [[CrossAccountDataBaseManager sharedInstance].readWriteDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            [self.account saveWithTransaction:transaction];
        }];
    }
}

//auto login
- (void)autoLogin
{
    NSArray * array = [[CrossAccountDataBaseManager sharedInstance] allAutoLoginAccounts];
    for (CrossAccount * account in array)
    {
        if (account.auotoLogin)
        {
            CrossAccount * newAccount = [CrossAccount accountForAccountType: account.accountType];
            if(newAccount)
            {
                newAccount.userName = account.userName;
                newAccount.password = account.password;
                newAccount.auotoLogin = account.auotoLogin;
                newAccount.uniqueId = account.uniqueId;
            }
            [self loginWithAccount:newAccount];
            break;
        }
    }
}

#pragma mark -- init notification
-(void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRegisterFailed:)
                                                 name:CrossProtocolRegisterFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRegisterSuccess:)
                                                 name:CrossProtocolRegisterSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSucess:)
                                                 name:CrossProtocolLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginFailed:)
                                                 name:CrossProtocolLoginFailed object:nil];
}

-(void)uninitNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -- login / register listener
- (void)onRegisterSuccess: (NSNotification *)notification
{
    [self hideHUD];
    [self loginWithAccount:self.account];
}


- (void) onRegisterFailed: (NSNotification *)notification
{
    [self hideHUD];
}


- (void)onLoginSucess:(NSNotification *)notification
{
    [self hideHUD];
}

- (void)onLoginFailed:(NSNotification *)notification
{
    [self hideHUD];
}

#pragma mark -- show & hide hud
- (void)showHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *window = [[UIApplication sharedApplication] keyWindow];
        MBProgressHUD *hud = [MBProgressHUD HUDForView:window];
        if (!hud)
        {
            hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        }
        else
        {
            [hud show:YES];
        }
    });
}

- (void)hideHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *window = [[UIApplication sharedApplication] keyWindow];
        [MBProgressHUD hideHUDForView:window animated:NO];
    });
}

-(void)dealloc
{
    [self uninitNotification];
}

@end
