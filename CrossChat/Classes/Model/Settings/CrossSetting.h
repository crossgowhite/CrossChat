//
//  CrossSetting.h
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class CrossSetting;

/*
 * CrossSetting Delegate Protocol
 * Target: Show Detail View Controller for click
 */

@protocol CrossSettingDelegate <NSObject>
@required
- (void) Setting:(CrossSetting*)setting showDetailViewControllerClass:(Class)viewControllerClass;

@optional
- (void) refreshView;
@end


//typedef enum {
//    PUSH,
//    PRESENT
//}SHOWDETAILCONTROLLERANIMATION;

typedef void (^CrossSettingActionBlock)(void);

@interface CrossSetting : NSObject

@property (nonatomic, strong, readonly) NSString *      title;
@property (nonatomic, strong, readonly) NSString *      settingDescription;

@property (nonatomic, strong) NSString *                imageName;

@property (nonatomic, weak) id<CrossSettingDelegate>    delegate;
@property (nonatomic, copy) CrossSettingActionBlock     actionBlock;
//@property (nonatomic) SHOWDETAILCONTROLLERANIMATION     animation;

@property (nonatomic, strong) UIImage *                 image;

- (id) initWithTitle:(NSString *)newTitle description:(NSString *)newDescription;

@end
