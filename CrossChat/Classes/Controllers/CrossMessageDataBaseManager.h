//
//  CrossMessageDataBaseManager.h
//  CrossChat
//
//  Created by chaobai on 15/11/2.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CrossBuddy;
@class CrossMessage;

@interface CrossMessageDataBaseManager : NSObject

- (id) initWithBuddy:(CrossBuddy*)buddy;

- (NSArray *)MessageList;

- (void) persistenceMessage:(CrossMessage*)message completeBlock:(dispatch_block_t)block;

@end
