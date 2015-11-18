//
//  CrossMessageViewManager.h
//  CrossChat
//
//  Created by chaobai on 15/11/4.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrossViewManager.h"

@class CrossBuddy;

@interface CrossMessageViewManager : CrossViewManager

- (id) initWithCrossBuddy:(CrossBuddy *)buddy;

- (NSIndexPath*) getLastMessageFrameIndexPath;

@end
