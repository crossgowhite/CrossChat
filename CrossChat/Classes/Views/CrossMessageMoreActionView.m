//
//  CrossMessageMoreActionView.m
//  CrossChat
//
//  Created by chaobai on 15/11/27.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossMessageMoreActionView.h"

@interface CrossMessageMoreActionView ()

@property (nonatomic,strong) UIImageView *  backImageView;
@property (nonatomic,strong) UIButton *     picBtn;
@end

@implementation CrossMessageMoreActionView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSubView];
    }
    return self;
}

- (void)initSubView
{
    self.backgroundColor = [UIColor darkGrayColor];

    self.picBtn = [self buttonWith:@"sendpic.png" action:@selector(picBtnPress:)];
    [self.picBtn setFrame:CGRectMake(0,0, 50, 50)];
    [self.picBtn setCenter:CGPointMake(40, self.frame.size.height*0.5)];
    [self addSubview:self.picBtn];
}

-(UIButton *)buttonWith:(NSString *)noraml action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:noraml] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:noraml] forState:UIControlStateHighlighted];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

//-(void)addBtnPress:(UIButton *)image
-(void)picBtnPress:(UIButton *)image
{
    if([self.delegate respondsToSelector:@selector(onPicBtnPress)])
    {
        [self.delegate onPicBtnPress];
    }
}

- (void)dealloc
{
    self.delegate = nil;
}

@end
