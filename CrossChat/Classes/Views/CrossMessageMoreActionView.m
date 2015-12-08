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
@property (nonatomic,strong) UIButton *     selectPicBtn;
@property (nonatomic,strong) UIButton *     takePicBtn;
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

    self.selectPicBtn = [self buttonWith:@"sendpic.png" action:@selector(selectPicBtnPress:)];
    [self.selectPicBtn setFrame:CGRectMake(0,0, 50, 50)];
    [self.selectPicBtn setCenter:CGPointMake(40, self.frame.size.height*0.5)];
    [self addSubview:self.selectPicBtn];
    
    self.takePicBtn = [self buttonWith:@"takepic.png" action:@selector(takePicBtnPress:)];
    [self.takePicBtn setFrame:CGRectMake(0,0, 50, 50)];
    [self.takePicBtn setCenter:CGPointMake(120, self.frame.size.height*0.5)];
    [self addSubview:self.takePicBtn];
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
-(void)selectPicBtnPress:(UIButton *)image
{
    if([self.delegate respondsToSelector:@selector(onSelectPicBtnPress)])
    {
        [self.delegate onSelectPicBtnPress];
    }
}

-(void)takePicBtnPress:(UIButton*)image
{
    if([self.delegate respondsToSelector:@selector(onTakePicBtnPress)])
    {
        [self.delegate onTakePicBtnPress];
    }
}

- (void)dealloc
{
    self.delegate = nil;
}

@end
