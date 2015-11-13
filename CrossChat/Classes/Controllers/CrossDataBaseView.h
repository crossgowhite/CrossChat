//
//  CrossDataBaseView.h
//  CrossChat
//
//  Created by chaobai on 15/9/29.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * CrossAllAccountDatabaseViewExtensionName;
extern NSString * CrossAllAccountGroup;

extern NSString * CrossAllBuddyDatabaseViewExtensionName;
extern NSString * CrossAllBuddyGroup;

@interface CrossDataBaseView : NSObject


+ (BOOL)registerAllAccountsDatabaseView;
+ (BOOL)registerAllBuddysDatabaseView;
@end
