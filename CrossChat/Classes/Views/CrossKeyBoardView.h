//
//  CrossKeyBoardView.h
//  CrossChat
//
//  Created by chaobai on 15/11/9.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CrossKeyBoardView;

@protocol KeyBordViewDelegate <NSObject>

-(void)KeyBordView:(CrossKeyBoardView *)keyBoardView textFieldReturn:(UITextField *)textField;
-(void)KeyBordView:(CrossKeyBoardView *)keyBoardView textFieldBegin:(UITextField *)textField;

-(void)beginRecord;
-(void)finishRecord;

-(void)endEdit;

-(void)onAddBtnPress;

@end

@interface CrossKeyBoardView : UIView

@property (nonatomic,weak) id<KeyBordViewDelegate> delegate;
@end
