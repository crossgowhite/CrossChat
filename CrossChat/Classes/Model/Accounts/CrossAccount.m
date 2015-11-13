//
//  CrossAccount.m
//  CrossChat
//
//  Created by chaobai on 15/9/23.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossAccount.h"
#import "CrossXMPPAccount.h"
#import "String.h"

@interface CrossAccount () <NSCoding>

@end


@implementation CrossAccount


//- (instancetype) initWithUserName:(NSString *)newUsername password:(NSString*) newPassword autoLogin:(BOOL)newAutoLogin
//{
//    self = [super init];
//    
//    if (self) {
//        self.userName = newUsername;
//        self.password = newPassword;
//        self.auotoLogin = newAutoLogin;
//    }
//    
//    return self;
//}
//
//+ (instancetype) AccountWithUserName:(NSString *)newUsername password:(NSString*) newPassword autoLogin:(BOOL)newAutoLogin
//{
//    return [[self alloc]initWithUserName:newUsername password:newPassword autoLogin:newAutoLogin];
//}

- (id) init
{
    self = [super init];
    if(self)
    {
        self.accountType = CrossAccountTypeNone;
        self.avatarImageData = nil;
    }
    return self;
}

- (NSString *) displayName
{
    return [NSString stringWithFormat:@"%@@%@",self.userName,XMPP_SERVER_ADDRESS_STRING];
}


- (Class) protocolClass
{
    return nil;
}


- (UIImage *) accountImage
{
    if (self.avatarImageData)
    {
        return [UIImage imageWithData:self.avatarImageData];
    }
    return nil;
}

- (CrossProtocolType) protocolType
{
    return CrossProtocolTypeNone;
}

- (id) initWithAccountType: (CrossAccountType)newAccountType
{
    self = [self init];
    if(self)
        self.accountType = newAccountType;
    return self;
}


+ (CrossAccount *)accountForAccountType: (CrossAccountType)accountType
{
    CrossAccount * account = nil;
    
    switch (accountType) {
        case CrossAccountTypeNone:
            account = [[CrossAccount alloc]init];
            break;
        case CrossAccountTypeXMPP:
            account = [[CrossXMPPAccount alloc]init];
            break;
        default:
            break;
    }
    
    return account;
}

+ (NSString *) collection
{
    return NSStringFromClass([CrossAccount class]);
}

- (void)encodeWithCoder: (NSCoder *)aCoder
{
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeBool:self.auotoLogin forKey:@"autoLogin"];
    [aCoder encodeInteger:self.accountType forKey:@"accountType"];
    [aCoder encodeObject:self.uniqueId forKey:@"uniqueId"];
    [aCoder encodeObject:self.avatarImageData forKey:@"avatarImageData"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if(!self)
    {
        return nil;
    }
    self.userName = [aDecoder decodeObjectForKey:@"userName"];
    self.password = [aDecoder decodeObjectForKey:@"password"];
    self.auotoLogin = [aDecoder decodeBoolForKey:@"autoLogin"];
    self.accountType = [aDecoder decodeIntegerForKey:@"accountType"];
    self.uniqueId = [aDecoder decodeObjectForKey:@"uniqueId"];
    self.avatarImageData = [aDecoder decodeObjectForKey:@"avatarImageData"];
    return self;
}


+ (NSArray *)allAccountsWithTransaction: (YapDatabaseReadTransaction*)transaction
{
    NSMutableArray *accounts = [NSMutableArray array];
    NSArray * allAccountKeys = [transaction allKeysInCollection:[CrossAccount collection]];
    [allAccountKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [accounts addObject:[transaction objectForKey:obj inCollection:[CrossAccount collection]]];
    }];
    return accounts;
}

+ (instancetype)fetchObjectWithUniqueID:(NSString*)uniqueID transaction:(YapDatabaseReadTransaction*)transaction
{
    return [transaction objectForKey:uniqueID inCollection: NSStringFromClass([self class])];
}
@end
