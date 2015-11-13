//
//  CrossBuddy.m
//  CrossChat
//
//  Created by chaobai on 15/10/27.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossBuddy.h"


@implementation CrossBuddy

- (id) init
{
    self = [super init];
    if(self)
        self.status = CrossBuddyStatusOffline;
    return self;
}

- (UIImage *)avatarImage
{
    return [UIImage imageWithData:self.avatarData];
}

- (void)encodeWithCoder: (NSCoder *)aCoder
{
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.displayName forKey:@"displayName"];
    [aCoder encodeObject:self.composingMessageString forKey:@"composingMessageString"];
    [aCoder encodeObject:self.statusMessage forKey:@"statusMessage"];
    [aCoder encodeInteger:self.status forKey:@"status"];
    [aCoder encodeObject:self.lastMessageDate forKey:@"lastMessageDate"];
    [aCoder encodeObject:self.avatarData forKey:@"avatarData"];
    [aCoder encodeObject:self.uniqueId forKey:@"uniqueId"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if(!self)
    {
        return nil;
    }
    self.userName = [aDecoder decodeObjectForKey:@"userName"];
    self.displayName = [aDecoder decodeObjectForKey:@"displayName"];
    self.composingMessageString = [aDecoder decodeObjectForKey:@"composingMessageString"];
    self.statusMessage = [aDecoder decodeObjectForKey:@"statusMessage"];
    self.status = [aDecoder decodeIntegerForKey:@"status"];
    self.lastMessageDate = [aDecoder decodeObjectForKey:@"lastMessageDate"];
    self.avatarData = [aDecoder decodeObjectForKey:@"avatarData"];
    self.uniqueId = [aDecoder decodeObjectForKey:@"uniqueId"];
    return self;
}

+ (NSString *) collection
{
    return NSStringFromClass([CrossBuddy class]);
}

+ (NSArray *)allBuddysWithTransaction: (YapDatabaseReadTransaction*)transaction
{
    NSMutableArray *buddys = [NSMutableArray array];
    NSArray * allBuddyKeys = [transaction allKeysInCollection:[CrossBuddy collection]];
    [allBuddyKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [buddys addObject:[transaction objectForKey:obj inCollection:[CrossBuddy collection]]];
    }];
    return buddys;
}

@end
