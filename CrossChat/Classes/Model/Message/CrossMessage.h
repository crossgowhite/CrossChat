//
//  CrossMessage.h
//  CrossChat
//
//  Created by chaobai on 15/10/30.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrossYapDatabaseObject.h"

//<NSCoding,NSCopying>
@interface CrossMessage : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *text;
@property (nonatomic) NSNumber  *read;
@property (nonatomic) NSNumber  *incoming;
@property (nonatomic, strong) NSString *owner;

- (instancetype)initWithDict:(NSDictionary*)dict;

+ (instancetype)CrossMessageWithDict:(NSDictionary*)dict;

+ (instancetype)CrossMessageWithText:(NSString *)text read:(NSNumber*)read incoming:(NSNumber*)incoming owner:(NSString*)owner;

- (NSDictionary *)encodeIntoDictionary;
@end
