//
//  CrossMessageViewManager.h
//  CrossChat
//
//  Created by chaobai on 15/11/4.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CrossMessageFrame;
@class CrossBuddy;

@interface CrossMessageViewManager : NSObject

@property (nonatomic, strong) NSMutableArray *  messageFrameGroups;

- (id) initWithCrossBuddy:(CrossBuddy *)buddy;

- (void) refreshMessageFrameGroup;

- (void) cleanMessageFrameGroup;

- (CrossMessageFrame*) messageFrameAtSection:(NSUInteger)section row:(NSInteger)row;

- (NSString*) stringForGroupInSection:(NSUInteger)section;

- (NSUInteger) numberOfMessageFramesInSection:(NSUInteger)section;

- (NSIndexPath*) getLastMessageFrameIndexPath;
@end
