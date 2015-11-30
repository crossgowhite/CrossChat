//
//  CrossMessageMoreActionView.h
//  CrossChat
//
//  Created by chaobai on 15/11/27.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreActionDelegate <NSObject>

-(void)onPicBtnPress;

@end

@interface CrossMessageMoreActionView : UIView

@property (nonatomic,weak) id<MoreActionDelegate> delegate;

@end
