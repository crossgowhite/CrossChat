//
//  CrossMessageManager.h
//  CrossChat
//
//  Created by chaobai on 15/11/2.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CrossBuddy;
@class CrossMessageDataBaseManager;

@interface CrossMessageManager : NSObject

+ (CrossMessageManager*) sharedInstance; // Singleton method

- (CrossMessageDataBaseManager*) databaseManagerForBuddy: (CrossBuddy *)buddy;
@end
