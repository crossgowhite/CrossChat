//
//  CrossBuddyManager.h
//  CrossChat
//
//  Created by chaobai on 15/10/27.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrossBuddyManager : NSObject

+ (CrossBuddyManager*) sharedInstance;

- (NSArray *)getAllBuddyList;
- (NSArray *)getInConversationBuddyList;
@end
