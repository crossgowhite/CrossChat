//
//  CrossNewAccountViewController.h
//  CrossChat
//
//  Created by chaobai on 15/9/22.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    CREATE_NEW_ACCOUNT_ACTION,
    LOGIN_EXISTED_ACCOUNT_ACTION
}NEWACCOUNTACTION;

@class CrossAccount;

@interface CrossNewAccountViewController : UIViewController

- (id)initWithAccount :(CrossAccount *)newAccount;
@property NEWACCOUNTACTION action;

@end
