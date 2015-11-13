//
//  CrossDataBaseManager.h
//  CrossChat
//
//  Created by chaobai on 15/9/28.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YapDatabase.h"
#import "CrossAccount.h"



@interface CrossAccountDataBaseManager : NSObject

@property (nonatomic, strong) YapDatabase * database;
@property (nonatomic, strong) YapDatabaseConnection *readWriteDatabaseConnection;


- (BOOL) setupDataBaseWithName :(NSString *)name;

+ (instancetype)sharedInstance;

- (YapDatabaseConnection *) newConnection;

- (BOOL) accountWhetherExisted:(CrossAccount*)newAccount;

@end
