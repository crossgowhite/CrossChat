//
//  CrossAlertViewController.m
//  CrossChat
//
//  Created by chaobai on 15/9/23.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossAlertViewController.h"
#import "CrossAlertAction.h"
#import "CrossAlertAction.h"

@interface CrossAlertViewController ()

@end

@implementation CrossAlertViewController

+ (instancetype) crossAlertViewControllerWithTitle:(NSString *)newTitle message:(NSString *)newMessage preferredStyle:(UIAlertControllerStyle)newStyle AlertActionArray:(NSArray *)newArray
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:newTitle message:newMessage preferredStyle:newStyle];
    
    for (id obj in newArray) {
        CrossAlertAction * actionObj = (CrossAlertAction *)obj;
        
        UIAlertAction * actionItem = [UIAlertAction actionWithTitle:actionObj.title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            actionBlock actionBlock = actionObj.actionBlock;
            if (actionBlock)
            {
                actionBlock();
            }
        }];
        [alertController addAction:actionItem];
    }    
    return alertController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
