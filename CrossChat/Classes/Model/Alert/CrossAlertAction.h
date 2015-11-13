//
//  CrossAlertAction.h
//  CrossChat
//
//  Created by chaobai on 15/9/23.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^actionBlock)(void);

@interface CrossAlertAction : NSObject

@property (nonatomic, strong) actionBlock      actionBlock;
@property (nonatomic, strong) NSString *       title;

- (instancetype) initWithTitle:(NSString*)newTitle actionBlock:(actionBlock)newActionBlock;

@end
