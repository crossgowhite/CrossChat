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
#import "CrossConstants.h"
#import "CrossMessage.h"

#import "CrossBuddyDataBaseManager.h"
#import "CrossAccountDataBaseManager.h"
#import "CrossMessageManager.h"
#import "CrossMessageDataBaseManager.h"

#import "CrossXMPPMessageStatus.h"
#import "CrossXMPPMessageDecoder.h"

#import "MBProgressHUD.h"

static CrossChatService * sharedService = nil;

@interface CrossChatService ()



@end


@implementation CrossChatService

- (id) init
{
    self = [super init];
    
    if (self)
    {        
        [self initNotification];
        
        //setup account database
        self.accountDataBaseManager = [[CrossAccountDataBaseManager alloc]initWithDataBaseName:CrossYapDatabaseName];
        
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogouted:)
                                                 name:CrossProtocolLogouted object:nil];
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
    //setup buddy db
    self.buddyDataBaseManager = [[CrossBuddyDataBaseManager alloc]initWithAccountUniqueId:self.account.uniqueId dbName:CrossYapBuddyDatabaseName];
    self.messageManager = [[CrossMessageManager alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReceiveMessage:) name:CrossXMPPMessageReceived object:nil];
    
    [self hideHUD];
}

- (void)onLoginFailed:(NSNotification *)notification
{
    [self hideHUD];
}

- (void)onLogouted:(NSNotification *)notification
{
    [self setBuddyDataBaseManager:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CrossXMPPMessageReceived object:nil];
    [self setMessageManager:nil];
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

#pragma mark -- Account relate
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

//persistence Account
- (void)persistenceAccount:(CrossAccount*)account
{
    if (account)
    {
        self.account = account;
        [self.accountDataBaseManager.readWriteDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            [self.account saveWithTransaction:transaction];
        }];
    }
}

//auto login
- (void)autoLogin
{
    
    NSArray * array = [self allAutoLoginAccounts];
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

- (NSArray *)allAutoLoginAccounts
{
    __block NSArray *accounts = nil;
    
    [self.accountDataBaseManager.readWriteDatabaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        accounts = [CrossAccount allAccountsWithTransaction:transaction];
    }];
    
    return accounts;
}

#pragma mark -- Buddy relate
- (NSArray *)getAllBuddyList
{
    if ([self getAccountConnectionStatus] == CrossProtocolConnectionStatusConnected && self.buddyDataBaseManager)
        return [self.buddyDataBaseManager getAllBuddyList];
    
    return nil;
}

//all in conversation friend list
- (NSArray *)getInConversationBuddyList
{
    if ([self getAccountConnectionStatus] == CrossProtocolConnectionStatusConnected && self.buddyDataBaseManager)
        return [self.buddyDataBaseManager getInConversationBuddyList];

    return nil;
}

#pragma mark -- Message relate
//send message
- (void)sendMessage:(CrossMessage *)newMessage completeBlock:(dispatch_block_t)block
{

    if (self.account && [self getAccountConnectionStatus] == CrossProtocolConnectionStatusConnected)
    {
        //1.send message
        id <CrossProtocol> protocol = [[CrossProtocolManager sharedInstance] protocolForAccount:self.account];
        if (protocol)
        {
            [protocol sendMessage:newMessage];
        }
        [self handleMessage:newMessage completeBlock:block];
    }
}

//received message
- (void)ReceiveMessage:(NSNotification*)notification
{
    XMPPMessage * message = notification.object;
    NSString * messageText = [CrossXMPPMessageDecoder getMessageTextWithMessage:message];
    NSString * fromuser = [CrossXMPPMessageDecoder getFromUserNameWithMessage:message];
    if (messageText)
    {
        CrossMessage * message = [CrossMessage CrossMessageWithText:messageText read:[NSNumber numberWithInteger:1] incoming:[NSNumber numberWithInteger:1] owner:fromuser];
        
        [self handleMessage:message completeBlock:^(void){
            [[NSNotificationCenter defaultCenter] postNotificationName:CrossMessageReceived object:nil];}];
    }
}

- (void)handleMessage:(CrossMessage*)message completeBlock:(dispatch_block_t)block
{
    void (^updateBuddy_complete_block_t)(CrossBuddy*) = ^(CrossBuddy* buddy)
    {
        //2. save message
        [self.messageManager persistenceMessage:message Buddy:buddy completeBlock:^(void){
            if (block)
                block();
        }];
    };
    
    //1. save buddy
    [self.buddyDataBaseManager updateBuddyStatusMessage:message.text buddyName:message.owner completeBlock:updateBuddy_complete_block_t];
}

- (NSArray *)MessageListWithBuddy:(CrossBuddy*)buddy
{
    if (self.messageManager && self.account && [self getAccountConnectionStatus] == CrossProtocolConnectionStatusConnected)
    {
        CrossMessageDataBaseManager * manaeger = [self.messageManager databaseManagerForBuddy :buddy];
        if (manaeger)
        {
            return [manaeger MessageList];
        }
    }
    return nil;
}


-(void)dealloc
{
    [self uninitNotification];
}

@end
