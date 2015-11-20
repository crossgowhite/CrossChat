//
//  CrossMessageManager.h
//  CrossChat
//
//  Created by chaobai on 15/11/2.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CrossBuddy;
@class CrossMessage;
@class CrossMessageDataBaseManager;

@interface CrossMessageManager : NSObject

- (CrossMessageDataBaseManager*)databaseManagerForBuddy: (CrossBuddy *)buddy;

- (void)persistenceMessage:(CrossMessage*)message Buddy:(CrossBuddy*)buddy completeBlock:(dispatch_block_t)block;
@end
