//
//  CrossAccount.h
//  CrossChat
//
//  Created by chaobai on 15/9/23.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrossProtocol.h"
#import "CrossYapDatabaseObject.h"

@import UIKit;

typedef NS_ENUM(NSInteger, CrossAccountType) {
    CrossAccountTypeNone        = 0,
    CrossAccountTypeXMPP        = 1
};

@interface CrossAccount : CrossYapDatabaseObject

@property (nonatomic, strong) NSString *        userName;
@property (nonatomic, strong) NSString *        displayName;
@property (nonatomic, strong) NSString *        password;
@property (nonatomic) BOOL                      auotoLogin;
@property (nonatomic) CrossAccountType          accountType;
@property (nonatomic, strong) NSData   *        avatarImageData;

- (NSString*)displayName;
- (Class)protocolClass;
- (UIImage *)accountImage;
- (CrossProtocolType)protocolType;

+ (NSString *) collection;

- (id) initWithAccountType : (CrossAccountType) newAccountType;
+ (CrossAccount *)accountForAccountType:(CrossAccountType)accountType;

+ (NSArray *)allAccountsWithTransaction:(YapDatabaseReadTransaction*)transaction;

+ (instancetype)fetchObjectWithUniqueID:(NSString*)uniqueID transaction:(YapDatabaseReadTransaction*)transaction;
@end
