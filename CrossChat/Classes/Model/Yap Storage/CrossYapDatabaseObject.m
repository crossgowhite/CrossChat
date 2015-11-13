//
//  CrossYapDatabaseObject.m
//  CrossChat
//
//  Created by chaobai on 15/9/28.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossYapDatabaseObject.h"
#import "CrossAccount.h"

@interface CrossYapDatabaseObject ()


@end

@implementation CrossYapDatabaseObject


- (id) init
{
    self = [super init];
    
    if (self) {
        _uniqueId = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (instancetype)initWithUniqueId:(NSString *)uniqueId
{
    if (self = [super init]) {
        _uniqueId = uniqueId;
    }
    return self;
}

//+ (NSString *) collection
//{
//    return NSStringFromClass([self class]);
//}

- (void) saveWithTransaction: (YapDatabaseReadWriteTransaction *)transaction
{
    [transaction setObject:self forKey:self.uniqueId inCollection:[[self class] collection]];
}


- (void)removeWithTransaction: (YapDatabaseReadWriteTransaction *)transaction
{
    [transaction removeObjectForKey:self.uniqueId inCollection:[[self class] collection]];
}


+ (instancetype)fetchObjectWithUniqueID:(NSString*)uniqueID transaction:(YapDatabaseReadTransaction*)transaction
{
    return [transaction objectForKey:uniqueID inCollection: NSStringFromClass([self class])];
}

@end
