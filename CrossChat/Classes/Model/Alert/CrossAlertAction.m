//
//  CrossAlertAction.m
//  CrossChat
//
//  Created by chaobai on 15/9/23.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossAlertAction.h"

@implementation CrossAlertAction

- (instancetype) initWithTitle:(NSString *)newTitle actionBlock:(actionBlock)newActionBlock
{
    self = [super init];
    
    if (self) {
        self.title = newTitle;
        self.actionBlock = newActionBlock;
    }
    
    return self;
}

@end
