//
//  CrossMessageTextView.m
//  CrossChat
//
//  Created by chaobai on 15/11/3.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossMessageTextView.h"
#import "CrossMessage.h"

#define kContentStartMargin 25

@implementation CrossMessageTextView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backImageView=[[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled=YES;
        [self addSubview:self.backImageView];
        
        self.textLabel=[[UILabel alloc]init];
        self.textLabel.numberOfLines=0;
        self.textLabel.textAlignment=NSTextAlignmentLeft;
        self.textLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
        [self addSubview:self.textLabel];
        
        self.imageView=[[UIImageView alloc]init];
        [self addSubview:self.imageView];
        
        self.indicator = [[UIActivityIndicatorView alloc]init];
        [self addSubview:self.indicator];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.backImageView.frame=self.bounds;
    CGFloat contentLabelX=0;
    
    if ([self.message.incoming intValue] == 1)
    {
        contentLabelX=kContentStartMargin*0.9;
    }
    else if([self.message.incoming intValue] == 0)
    {
        contentLabelX=kContentStartMargin*0.5;
    }
    
    self.textLabel.frame=CGRectMake(contentLabelX, -3, self.frame.size.width-kContentStartMargin-5, self.frame.size.height);
    self.imageView.frame=CGRectMake(contentLabelX, 3, self.frame.size.width-kContentStartMargin-10, self.frame.size.height-15);
    [self.indicator setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
}


@end
