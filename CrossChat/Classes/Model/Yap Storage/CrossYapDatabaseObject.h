//
//  CrossYapDatabaseObject.h
//  CrossChat
//
//  Created by chaobai on 15/9/28.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YapDatabaseTransaction.h"

@interface CrossYapDatabaseObject : NSObject
@property (nonatomic) NSString * uniqueId;

- (instancetype)initWithUniqueId:(NSString *)uniqueId;


- (void)saveWithTransaction:(YapDatabaseReadWriteTransaction *)transaction;
- (void)removeWithTransaction:(YapDatabaseReadWriteTransaction *)transaction;

//+ (NSString *)collection;

+ (instancetype)fetchObjectWithUniqueID:(NSString*)uniqueID transaction:(YapDatabaseReadTransaction*)transaction;


@end
