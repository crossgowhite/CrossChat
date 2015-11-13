//
//  AppDelegate.m
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "AppDelegate.h"
#import "CrossConversationViewController.h"
#import "CrossAccountDataBaseManager.h"
#import "CrossConstants.h"
#import "CrossAccountManager.h"
#import "CrossProtocol.h"
#import "CrossProtocolManager.h"

#import "MBProgressHUD.h"

@interface AppDelegate ()

//1. home tabbar view controller
@property (strong, nonatomic) UITabBarController * tabBarCtrl;
@property (nonatomic, strong) MBProgressHUD * HUD;
@property (nonatomic, strong) MBProgressHUD * successHUD;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //DataBase part
    [[CrossAccountDataBaseManager sharedInstance] setupDataBaseWithName :CrossYapDatabaseName];
    
    //Auto login
    [self autoLogin];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)autoLogin
{
    NSArray * array = [CrossAccountManager allAutoLoginAccounts];
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
            id <CrossProtocol> protocol = [[CrossProtocolManager sharedInstance]protocolForAccount:newAccount];
            
            if (protocol)
            {
                NSLog(@"Auto LOGING Account %@",newAccount.userName);
                [protocol login];
            }
            break;
        }
    }
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
