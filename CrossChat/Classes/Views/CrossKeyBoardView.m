//
//  CrossKeyBoardView.m
//  CrossChat
//
//  Created by chaobai on 15/11/9.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossKeyBoardView.h"
#import "String.h"

@interface CrossKeyBoardView() <UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *  backImageView;
@property (nonatomic,strong) UIButton *     voiceBtn;
@property (nonatomic,strong) UIButton *     imageBtn;
@property (nonatomic,strong) UIButton *     addBtn;
@property (nonatomic,strong) UIButton *     speakBtn;
@property (nonatomic,strong) UITextField *  textField;

@end


@implementation CrossKeyBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSubView];
    }
    return self;
}

-(void)initSubView
{
    self.backImageView=[[UIImageView alloc]initWithFrame:self.bounds];
    
    UIImage * image=[UIImage imageNamed:@"toolbar_bottom_bar.png"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width*0.6 topCapHeight:image.size.height*0.5];
    self.backImageView.image=image;
    [self addSubview:self.backImageView];
    
    self.voiceBtn=[self buttonWith:@"chat_bottom_voice_nor.png" hightLight:@"chat_bottom_voice_press.png" action:@selector(voiceBtnPress:)];
    [self.voiceBtn setFrame:CGRectMake(0,0, 33, 33)];
    [self.voiceBtn setCenter:CGPointMake(30, self.frame.size.height*0.5)];
    [self addSubview:self.voiceBtn];
    

    
    self.textField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 240, self.frame.size.height*0.8)];
    self.textField.returnKeyType=UIReturnKeySend;

    self.textField.center=CGPointMake(170, self.frame.size.height*0.5);
    self.textField.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
//    self.textField.placeholder=TYPEIN_STRING;
    self.textField.background=[UIImage imageNamed:@"chat_bottom_textfield.png"];
    self.textField.delegate=self;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    self.textField.leftView = paddingView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:self.textField];
    
    self.imageBtn=[self buttonWith:@"chat_bottom_smile_nor.png" hightLight:@"chat_bottom_smile_press.png" action:@selector(imageBtnPress:)];
    [self.imageBtn setFrame:CGRectMake(0, 0, 33, 33)];
    [self.imageBtn setCenter:CGPointMake(310, self.frame.size.height*0.5)];
    [self addSubview:self.imageBtn];
    
    self.addBtn=[self buttonWith:@"chat_bottom_up_nor.png" hightLight:@"chat_bottom_up_press.png" action:@selector(addBtnPress:)];
    [self.addBtn setFrame:CGRectMake(0, 0, 33, 33)];
    [self.addBtn setCenter:CGPointMake(350, self.frame.size.height*0.5)];
    [self addSubview:self.addBtn];
    
    self.speakBtn=[self buttonWith:nil hightLight:nil action:@selector(speakBtnPress:)];
    [self.speakBtn setTitle:HOLDTOSPEAK_STRING forState:UIControlStateNormal];
    [self.speakBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.speakBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.speakBtn setTitle:UNHOLDTOSTOP_STRING forState:(UIControlState)UIControlEventTouchDown];
    [self.speakBtn setBackgroundColor:[UIColor whiteColor]];
    CGRect frame = self.textField.frame;
    CGFloat width = frame.size.width -1;
    CGFloat y = frame.origin.y +2;
    CGFloat heigth = frame.size.height -7;
    frame.size.height = heigth;
    frame.size.width = width;
    frame.origin.y = y;
    [self.speakBtn setFrame:frame];
    [self.speakBtn.layer setMasksToBounds:YES];
    [self.speakBtn.layer setCornerRadius:10.0];
    [self.speakBtn.layer setBorderWidth:1.0];
    self.speakBtn.hidden=YES;
    [self addSubview:self.speakBtn];
}

-(UIButton *)buttonWith:(NSString *)noraml hightLight:(NSString *)hightLight action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:noraml] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hightLight] forState:UIControlStateHighlighted];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


#pragma mark -- action
-(void)touchDown:(UIButton *)voice
{
    NSLog(@"touchDown");
    if([self.delegate respondsToSelector:@selector(beginRecord)])
    {
        [self.delegate beginRecord];
    }
}

//after click hold speak
-(void)speakBtnPress:(UIButton *)voice
{
    NSLog(@"speakBtnPress");
    if([self.delegate respondsToSelector:@selector(finishRecord)])
    {
        [self.delegate finishRecord];
    }
}

-(void)voiceBtnPress:(UIButton *)voice
{
    NSString *normal,*hightLight;
    if(self.speakBtn.hidden==YES)
    {
        self.speakBtn.hidden=NO;
        self.textField.hidden=YES;
        normal=@"chat_bottom_keyboard_nor.png";
        hightLight=@"chat_bottom_keyboard_press.png";
    }
    else
    {
        self.speakBtn.hidden=YES;
        self.textField.hidden=NO;
        normal=@"chat_bottom_voice_nor.png";
        hightLight=@"chat_bottom_voice_press.png";
    }
    if([self.delegate respondsToSelector:@selector(endEdit)])
    {
        [self.delegate endEdit];
    }
    [voice setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [voice setImage:[UIImage imageNamed:hightLight] forState:UIControlStateHighlighted];
}

-(void)imageBtnPress:(UIButton *)image
{
    
    
}

-(void)addBtnPress:(UIButton *)image
{
    
    
}

#pragma mark -- UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(KeyBordView:textFieldBegin:)])
    {
        [self.delegate KeyBordView:self textFieldBegin:textField];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(KeyBordView:textFieldBegin:)])
    {
        [self.delegate KeyBordView:self textFieldReturn:textField];
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
