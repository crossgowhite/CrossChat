//
//  CrossMessage.h
//  CrossChat
//
//  Created by chaobai on 15/10/30.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CrossYapDatabaseObject.h"

typedef NS_ENUM(NSInteger, CrossMessageType) {
    CrossMessageText   = 1,
    CrossMessageImage  = 2
};

//<NSCoding,NSCopying>
@interface CrossMessage : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSData * data;
@property (nonatomic) NSNumber  *read;
@property (nonatomic) NSNumber  *incoming;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic) CrossMessageType type;

- (instancetype)initWithDict:(NSDictionary*)dict;

+ (instancetype)CrossMessageWithDict:(NSDictionary*)dict;

+ (instancetype)CrossMessageWithText:(NSString *)text read:(NSNumber*)read incoming:(NSNumber*)incoming owner:(NSString*)owner;

+ (instancetype)CrossMessageWithData:(NSData *)data read:(NSNumber*)read incoming:(NSNumber*)incoming owner:(NSString*)owner;

- (NSDictionary *)encodeIntoDictionary;
@end
