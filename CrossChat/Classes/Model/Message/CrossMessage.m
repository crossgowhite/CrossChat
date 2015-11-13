//
//  CrossMessage.m
//  CrossChat
//
//  Created by chaobai on 15/10/30.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossMessage.h"
#import "CrossTimerHelper.h"

@implementation CrossMessage

//- (id)initWithCoder:(NSCoder *)decoder
//{
//    // Decode
//    if (self = [super init])
//    {
//        self.date = [decoder decodeObjectForKey:@"date"];
//        self.text = [decoder decodeObjectForKey:@"text"];
//        self.read = [decoder decodeIntegerForKey:@"read"];
//        self.incoming = [decoder decodeIntegerForKey:@"incoming"];
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    // Encode
//    [encoder encodeObject:self.date forKey:@"date"];
//    [encoder encodeObject:self.text forKey:@"text"];
//    [encoder encodeInteger:self.read forKey:@"read"];
//    [encoder encodeInteger:self.incoming forKey:@"incoming"];
//}
//
//-(id)copyWithZone:(NSZone *)zone
//{
//    CrossMessage * copy = [[[self class] allocWithZone:zone]init];
//    copy.date = [self.date copy];
//    copy.text = [self.text copy];
//    copy.read = self.read;
//    copy.incoming = self.incoming;
//    return copy;
//}


- (instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text read:(NSNumber*)read incoming:(NSNumber*)incoming owner:(NSString *)owner
{
    if (self = [super init])
    {
        self.date = [CrossTimerHelper getCurrentDate];
        self.text = text;
        self.read = read;
        self.incoming = incoming;
        self.owner = owner;
    }
    return self;
}

+ (instancetype)CrossMessageWithDict:(NSDictionary*)dict
{
    return [[self alloc]initWithDict:dict];
}

- (NSDictionary *)encodeIntoDictionary
{
    NSMutableDictionary *plistDic = [[NSMutableDictionary alloc]init];
    [plistDic setObject:self.date forKey:@"date"];
    [plistDic setObject:self.text forKey:@"text"];
    [plistDic setObject:self.read forKey:@"read"];
    [plistDic setObject:self.incoming forKey:@"incoming"];
    [plistDic setObject:self.owner forKey:@"owner"];
    return plistDic;
}

+ (instancetype)CrossMessageWithText:(NSString *)text read:(NSNumber*)read incoming:(NSNumber*)incoming owner:(NSString*)owner
{
    return [[CrossMessage alloc] initWithText:text read:read incoming:incoming owner:owner];
}

@end
