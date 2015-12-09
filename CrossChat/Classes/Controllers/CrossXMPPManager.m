//
//  CrossXMPPManager.m
//  CrossChat
//
//  Created by chaobai on 15/9/24.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossXMPPManager.h"
#import "CrossXMPPAccount.h"

#import "CrossErrorManager.h"
#import "CrossXMPPError.h"
#import "CrossProtocolStatus.h"
#import "CrossBuddy.h"

#import "XMPPFramework.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPRosterMemoryStorage.h"

#import "XMPPPresence.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardTempModule.h"

#import "CrossBuddyDataBaseManager.h"
#import "CrossConstants.h"
#import "XMPPvCardCoreDataStorage.h"

#import "CrossAccountDataBaseManager.h"
#import "CrossXMPPMessageStatus.h"
#import "CrossMessage.h"
#import "CrossChatService.h"

#import "CrossXMPPMessageDecoder.h"

@interface CrossXMPPManager() <XMPPStreamDelegate>

//account
@property (nonatomic, strong) CrossXMPPAccount *                        account;

//connection status
@property (nonatomic) CrossProtocolConnectionStatus                     connectionStatus;

//xmpp services
@property (nonatomic, strong) XMPPStream *                    xmppStream;
@property (nonatomic, strong) XMPPRoster *                    xmppRoster;
//@property (nonatomic, strong) XMPPRosterCoreDataStorage *     xmppRosterStorage;
@property (nonatomic, strong) XMPPRosterMemoryStorage *       xmppRosterStorage;
@property (nonatomic, strong) XMPPvCardTempModule *                     xmppvCardTempModule;
@property (nonatomic, strong) XMPPvCardCoreDataStorage *                xmppvCardStorage;

@property (nonatomic, strong) XMPPJID *                                 JID;
@property (nonatomic, readwrite) BOOL                                   isXmppConnected;


@property (nonatomic) BOOL                                              isRegisteringNewAccount;
//work queue
@property (nonatomic) dispatch_queue_t                                  workQueue;


@end


@implementation CrossXMPPManager

#pragma mark -- init
- (id) init
{
    self = [super init];
    
    if (self)
    {
        NSString * queueLabel = [NSString stringWithFormat:@"%@.work.%@",[self class],self];
        self.workQueue = dispatch_queue_create([queueLabel UTF8String], 0);
        self.connectionStatus = CrossProtocolConnectionStatusDisconnected;
        self.isRegisteringNewAccount = NO;
    }
    
    return self;
}

#pragma mark -- Cross Protocol Implement
////about account
- (CrossAccount *)getProtocolAccount
{
    return self.account;
}

-(id) initWithAccount: (CrossAccount *)newAccount
{
    self = [self init];
    if (self) {
        NSAssert([newAccount isKindOfClass:[CrossXMPPAccount class]], @"Must have XMPP account");
        self.account = (CrossXMPPAccount *)newAccount;
        
        // Setup the XMPP stream
        [self setupStream];
    }
    return self;
}

//about connection status
- (CrossProtocolConnectionStatus)getProtocolConnectionStatus
{
    return self.connectionStatus;
}

#pragma mark -- message relate
//received message
- (void) xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"%@",[message description]);
    //1. handle receipt at xmpp manager
    [self handleReceiptsMessage:message];
    
    //2. post message out
    NSNotificationCenter * nc =[NSNotificationCenter defaultCenter];
    [nc postNotificationName:CrossXMPPMessageReceived object:message];
    
}

//send message
- (NSString*) sendMessage: (CrossMessage *)newMessage
{
    NSString * siid =[XMPPStream generateUUID];
    newMessage.messageID = siid;
    [self.xmppStream sendElement: [CrossXMPPMessageDecoder createMessageElementWithMessage: newMessage siID:siid ]];
    return siid;
}


- (void) handleReceiptsMessage: (XMPPMessage*)message
{
    XMPPMessage * reponse = [CrossXMPPMessageDecoder getReceiptsMessageWithXMPPMessage:message];
    if (reponse)
    {
        [[self xmppStream] sendElement:reponse];
    }
}

//about login
- (void) login
{
    self.isRegisteringNewAccount = NO;
    [self connectWithJID:[self.account displayName] password:self.account.password];
}

- (void) registerAccount
{
    self.isRegisteringNewAccount = YES;
    [self connectWithJID:[self.account displayName] password:self.account.password];
}

- (void) disconnect
{
    [self goOffline];
    [self.xmppStream disconnect];
}


#pragma mark -- xmpp service
- (void) setupStream
{
    if (self.xmppStream)
    {
        return;
    }
    
    self.xmppStream = [[XMPPStream alloc] init];
//    self.xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    self.xmppRosterStorage = [[XMPPRosterMemoryStorage alloc]init];
    self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterStorage];
    
    self.xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    self.xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:self.xmppvCardStorage dispatchQueue:self.workQueue];
    
    [self.xmppRoster activate: self.xmppStream];
    [self.xmppvCardTempModule activate: self.xmppStream];
    
    // Add ourself as a delegate to anything we may be interested in
    [self.xmppStream addDelegate:self delegateQueue:self.workQueue];
    [self.xmppRoster addDelegate:self delegateQueue:self.workQueue];
    [self.xmppvCardTempModule addDelegate:self delegateQueue:self.workQueue];
}

- (void)tearDownStream
{
    [self.xmppStream removeDelegate:self];
    [self.xmppRoster removeDelegate:self];
    [self.xmppvCardTempModule removeDelegate:self];
    
    [self.xmppRoster deactivate];
    [self.xmppvCardTempModule deactivate];
    
    [self.xmppRosterStorage clearAllUsersAndResourcesForXMPPStream:self.xmppStream];
    [self.xmppvCardStorage clearvCardTempForJID:self.JID xmppStream:self.xmppStream];
    
    self.xmppStream = nil;
    self.xmppRosterStorage = nil;
    self.xmppRoster = nil;
    self.xmppvCardStorage = nil;
    self.xmppvCardTempModule = nil;
}

//1. First step: connect to server
- (void) connectWithJID: (NSString *)myJID password:(NSString *)myPassword
{
    
    if(self.connectionStatus != CrossProtocolConnectionStatusDisconnected)
        return;
    
    CrossXMPPError * error = nil;
    NSString * domain = [self accountDomainWithError:&error];
    if(error)
    {
        [self failedInHandle:error];
        self.isRegisteringNewAccount = NO;
        return;
    }
    
    self.connectionStatus = CrossProtocolConnectionStatusConnecting;
    CrossXMPPAccount * account = (CrossXMPPAccount *)self.account;
    
    
    self.JID = [XMPPJID jidWithString:myJID resource:account.resource];
    
    //1. setting domain
    [self.xmppStream setHostName:domain];
    
    //2. setting jid
    [self.xmppStream setMyJID:self.JID];
    
    NSError * errorconnect = nil;
    //3. connect to server using jid without password
    if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&errorconnect])
    {
        self.connectionStatus = CrossProtocolConnectionStatusDisconnected;
        
        error = [[CrossErrorManager sharedInstance]errorForDomainType:CrossErrorDomainTypeXMPP error:errorconnect];
        
        [self failedInHandle:error];
        self.isRegisteringNewAccount = NO;
    }
    
}

//2. Step two: connected success, do auth or register
- (void) xmppStreamDidConnect: (XMPPStream *)sender
{
    if(self.isRegisteringNewAccount)
        [self registerNewAccountWithstream:sender];
    
    else
        [self authenticateWithStream:sender];
}

//3.1 Step three: register
- (void) registerNewAccountWithstream: (XMPPStream *)stream
{
    NSError * error = nil;
    if ([stream supportsInBandRegistration])
    {
        [stream registerWithPassword:self.account.password error:&error];
        if(error)
        {
            CrossXMPPError * errorhandle = [[CrossErrorManager sharedInstance]errorForDomainType:CrossErrorDomainTypeXMPP error:error];
            [self failedInHandle:errorhandle];
            self.isRegisteringNewAccount = NO;
        }
        
    }
    else
    {
        error = [NSError errorWithDomain:XMPPStreamErrorDomain code:XMPPStreamUnsupportedAction userInfo:nil];
        CrossXMPPError * errorhandle = [[CrossErrorManager sharedInstance]errorForDomainType:CrossErrorDomainTypeXMPP error:error];
        [self failedInHandle:errorhandle];
        self.isRegisteringNewAccount = NO;
    }
}

//3.1 Step three: authen
- (void) authenticateWithStream: (XMPPStream *)stream
{
    NSError * error = nil;
    BOOL status = YES;
    status = [stream authenticateWithPassword:self.account.password error:&error];
    if(error)
    {
        CrossXMPPError * errorhandle = [[CrossErrorManager sharedInstance]errorForDomainType:CrossErrorDomainTypeXMPP error:error];
        [self failedInHandle:errorhandle];
    }
}

//4.1 Step Four: register success
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    [self successInHanle];
    self.isRegisteringNewAccount = NO;
    //self.connectionStatus = CrossProtocolConnectionStatusConnected;
}

//4.1 Step Four: register fail
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    self.isRegisteringNewAccount = NO;
    NSError * error1 = [NSError errorWithDomain:XMPPStreamErrorDomain code:XMPPStreamUnsupportedAction userInfo:nil];
    CrossXMPPError * errorhandle = [[CrossErrorManager sharedInstance]errorForDomainType:CrossErrorDomainTypeXMPP error:error1];
    [self failedInHandle:errorhandle];
}

//4.1 Step Four: login sucess
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    [self goOnline];
    
    [self fetchvCardTempForJID:self.JID];

    self.connectionStatus = CrossProtocolConnectionStatusConnected;
    
    //    [self queryRoster];
    
    [self successInHanle];
}

//5 logout
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    self.connectionStatus = CrossProtocolConnectionStatusDisconnected;
    [[NSNotificationCenter defaultCenter] postNotificationName:CrossProtocolLogouted object:self];
}

//get user account domian
- (NSString *) accountDomainWithError:(CrossXMPPError**)error
{
    NSString * domainString = nil;
    CrossXMPPAccount * account = (CrossXMPPAccount *)self.account;
    
    if (account.domain.length)
    {
        domainString = account.domain;
    }
    else
    {
        NSError * error1 = [NSError errorWithDomain:XMPPStreamErrorDomain code:XMPPStreamInvalidState userInfo:nil];
        * error = [[CrossErrorManager sharedInstance]errorForDomainType:CrossErrorDomainTypeXMPP error:error1];
    }
    return domainString;
}


- (void)failedInHandle:(CrossXMPPError *)error
{

    if(error)
    {
        NSNotificationCenter * nc =[NSNotificationCenter defaultCenter];
        if(self.isRegisteringNewAccount)
            [nc postNotificationName:CrossProtocolRegisterFailed object:error];
        
        else
            [nc postNotificationName:CrossProtocolLoginFailed object:error];
    }
    
    self.connectionStatus = CrossProtocolConnectionStatusDisconnected;
}

- (void) successInHanle
{
    NSNotificationCenter * nc =[NSNotificationCenter defaultCenter];
    
    if (self.isRegisteringNewAccount)
        [nc postNotificationName:CrossProtocolRegisterSuccess object:self];
    
    else
        [nc postNotificationName:CrossProtocolLoginSuccess object:self];
}


#pragma mark -- set online & offline status
- (void) goOnline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [[self xmppStream] sendElement:presence];
}

- (void) goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}



#pragma mark -- query roster list
- (void) queryRoster
{
    NSXMLElement * query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement * iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID * myJID = self.xmppStream.myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"id" stringValue:@"1234567"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    [self.xmppStream sendElement:iq];
}


- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    NSNotificationCenter * nc =[NSNotificationCenter defaultCenter];
    [nc postNotificationName:CrossXMPPIQReceived object:iq];
    return YES;
}

-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    NSLog(@"Test %@",presence);
}

#pragma mark -- query XMPPvCardTempModule

- (void) fetchAvatarWithName:(NSString*)name
{
    [self fetchvCardTempForJID:[XMPPJID jidWithString:name]];
}

- (void)fetchvCardTempForJID:(XMPPJID *)jid
{
    [self.xmppvCardTempModule fetchvCardTempForJID:jid ignoreStorage:YES];
}

//call back for receive card info
-(void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp forJID:(XMPPJID *)jid
{
    XMPPvCardTemp * card = [self.xmppvCardTempModule vCardTempForJID:jid shouldFetch:YES];
    card.jid = jid;
    NSNotificationCenter * nc =[NSNotificationCenter defaultCenter];
    [nc postNotificationName:CrossXMPPAvatarDataReceived object:card];
}

#pragma mark -- keepalive
-(void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    sender.enableBackgroundingOnSocket = YES;
}


-(void)dealloc
{
    [self tearDownStream];
}
@end
