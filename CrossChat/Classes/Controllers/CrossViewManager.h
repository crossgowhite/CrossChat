//
//  CrossViewManager.h
//  CrossChat
//
//  Created by chaobai on 15/11/16.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CrossSetting;

@interface CrossViewManager : NSObject

@property (nonatomic, strong) NSMutableArray * arrayGroups;

- (void) refreshArrayGroup;

- (void) cleanArrayGroup;

- (id) itemAtSection:(NSUInteger)section row:(NSInteger)row;

- (NSString*) stringForGroupInSection:(NSUInteger)section;

- (NSUInteger) numberOfItemsInSection:(NSUInteger)section;

@end
