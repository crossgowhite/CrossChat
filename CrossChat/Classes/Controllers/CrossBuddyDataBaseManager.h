//
//  CrossBuddyDataBaseManager.h
//  CrossChat
//
//  Created by chaobai on 15/10/27.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YapDatabase.h"
#import "CrossBuddy.h"
extern NSString *const CrossYapDatabseMessageIdSecondaryIndex;
extern NSString *const CrossYapDatabseMessageIdSecondaryIndexExtension;

@interface CrossBuddyDataBaseManager : NSObject

@property (nonatomic, strong) YapDatabase * database;
@property (nonatomic, strong) YapDatabaseConnection *readWriteDatabaseConnection;


- (BOOL) setupDataBaseWithAccountUniqueId :(NSString *)accountName dbName:(NSString *)dbName;

+ (instancetype)sharedInstance;

- (YapDatabaseConnection *) newConnection;

- (void)persistenceBuddy:(CrossBuddy*)newBuddy;
- (void)persistenceBuddyPhotoWithUserName:(NSString *)username photoData:(NSData*)data;

- (CrossBuddy*) getCrossBuddyByName:(NSString*)username;
@end
