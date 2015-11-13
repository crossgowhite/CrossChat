//
//  CrossBuddy.h
//  CrossChat
//
//  Created by chaobai on 15/10/27.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossYapDatabaseObject.h"
@import UIKit;

typedef NS_ENUM(NSInteger, CrossBuddyStatus) {
    CrossBuddyStatusOffline   = 4,
    CrossBuddyStatusXa        = 3,
    CrossBuddyStatusDnd       = 2,
    CrossBuddyStatusAway      = 1,
    CrossBuddyStatusAvailable = 0
};

@interface CrossBuddy : CrossYapDatabaseObject

@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * displayName;
@property (nonatomic, strong) NSString * composingMessageString;
@property (nonatomic, strong) NSString * statusMessage;
@property (nonatomic) CrossBuddyStatus status;
@property (nonatomic, strong) NSDate * lastMessageDate;
@property (nonatomic, strong) NSData * avatarData;


- (UIImage *)avatarImage;
+ (NSString *) collection;

+ (NSArray *)allBuddysWithTransaction: (YapDatabaseReadTransaction*)transaction;
@end
