//
//  CrossMessageTextView.h
//  CrossChat
//
//  Created by chaobai on 15/11/3.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CrossMessage;

@interface CrossMessageTextView : UIView

//back grounde image
@property (nonatomic,strong) UIImageView *backImageView;

//content label
@property (nonatomic,strong) UILabel *textLabel;

//chart info
@property (nonatomic,strong) CrossMessage *message;

@end
