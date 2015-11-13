//
//  CrossProtocolManager.m
//  CrossChat
//
//  Created by chaobai on 15/9/24.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossProtocolManager.h"
#import "CrossAccount.h"

static CrossProtocolManager * sharedManger = nil;

@interface CrossProtocolManager()

@property (nonatomic, strong) NSMutableDictionary * protocolManagerDictionary;

@end

@implementation CrossProtocolManager

#pragma mark -- Singleton method Create
- (id) init
{
    self = [super init];
    if (self)
    {
        self.protocolManagerDictionary = [NSMutableDictionary new];
    }
    return self;
}

+ (CrossProtocolManager*) sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        sharedManger = [[super allocWithZone:NULL] init];
    });
    return sharedManger;
}

+ (id) allocWithZone: (NSZone *)zone
{
    return [CrossProtocolManager sharedInstance];
}

- (id) copyWithZone: (NSZone *)zone
{
    return [CrossProtocolManager sharedInstance];
}


#pragma mark -- Protocol Manager
- (id <CrossProtocol>) protocolForAccount: (CrossAccount *)newAccount
{
    NSObject <CrossProtocol> * protocol = [self.protocolManagerDictionary objectForKey:newAccount.uniqueId];
    if (!protocol && newAccount)
    {
        protocol = [[[newAccount protocolClass]alloc] initWithAccount:newAccount];
        if(protocol)
        {
            [self addProtocol:protocol forAccount:newAccount];
        }
    }
    return protocol;
}

- (void) removeProtocolForAccount: (CrossAccount *)newAccount
{
    @synchronized(self.protocolManagerDictionary)
    {
        NSObject <CrossProtocol> * protocol = [self.protocolManagerDictionary objectForKey:newAccount.uniqueId];
        
        //remove protocol connectionStatus kvo observer
        if(protocol)
        {
            [protocol removeObserver:self forKeyPath:NSStringFromSelector(@selector(connectionStatus))];
            [self.protocolManagerDictionary removeObjectForKey:newAccount.uniqueId];
        }
    }
}

#pragma mark -- add new protocol into protocolManagerDictionary
- (void) addProtocol: (id)protocol forAccount: (CrossAccount *)newAccount
{
    @synchronized(self.protocolManagerDictionary)
    {
        [self.protocolManagerDictionary setObject:protocol forKey:newAccount.uniqueId];
        
        //add kvo observer for connectionStatus change
        [protocol addObserver:self forKeyPath:NSStringFromSelector(@selector(connectionStatus)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
}

- (BOOL) existsProtocolForAccount: (CrossAccount *)newAccount
{
    if ([newAccount.uniqueId length])
    {
        @synchronized(self.protocolManagerDictionary)
        {
            if ([self.protocolManagerDictionary objectForKey:newAccount.uniqueId]) {
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark -- Observer for conncetion status kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(connectionStatus))])
    {
        CrossProtocolConnectionStatus newStatus = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        CrossProtocolConnectionStatus oldStatus = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
        
        switch (newStatus) {
            case CrossProtocolConnectionStatusConnected:
                self.numberOfConnectedAccount += 1;
                break;
            case CrossProtocolConnectionStatusDisconnected:
                self.numberOfConnectedAccount -= 1;
                break;
            default:
                break;
        }
        NSLog(@"Connection status changed newstatus %ld  oldstatus %ld",newStatus,oldStatus);
    }
}

//get the current connected account info
- (CrossAccount*) connectedAccount
{
    CrossAccount * account = nil;
    
    @synchronized(self.protocolManagerDictionary)
    {
        NSEnumerator * enumeratorValue = [self.protocolManagerDictionary objectEnumerator];
        
        for (NSObject *object in enumeratorValue)
        {
            NSObject <CrossProtocol> * protocol = object;
            if ([protocol getProtocolConnectionStatus] == CrossProtocolConnectionStatusConnected)
            {
                account = [protocol getProtocolAccount];
                break;
            }
        }
    }
    return account;
}
//- (void) removeProtocolForAccount:(CrossAccount *)newAccount;

@end
