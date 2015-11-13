//
//  CrossAlertViewController.h
//  CrossChat
//
//  Created by chaobai on 15/9/23.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CrossAlertViewController : UIAlertController

//@property (nonatomic, strong) NSArray *  actionArray;
//@property (nonatomic, strong) NSString * title;

+ (instancetype) crossAlertViewControllerWithTitle:(NSString *)newTitle message:(NSString *)newMessage preferredStyle:(UIAlertControllerStyle)newStyle AlertActionArray:(NSArray *)newArray;

@end
