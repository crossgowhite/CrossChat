//
//  CrossConversationSetting.h
//  CrossChat
//
//  Created by chaobai on 15/11/6.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossViewSetting.h"
#import "CrossBuddy.h"

@interface CrossConversationSetting : CrossViewSetting

@property (nonatomic, strong) CrossBuddy * buddy;

- (id) initWithBuddy:(CrossBuddy*)buddy Title:(NSString *)newTitle description:(NSString *)newDescription;
@end
