//
//  CrossMessageTableViewCell.m
//  CrossChat
//
//  Created by chaobai on 15/11/3.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossMessageTableViewCell.h"
#import "CrossMessageTextView.h"
#import "CrossMessageFrame.h"
#import "CrossMessage.h"

@interface CrossMessageTableViewCell ()

@property (nonatomic,strong) UIImageView *icon;

//chart content view, no include icon
@property (nonatomic,strong) CrossMessageTextView *messageTextView;


@end
@implementation CrossMessageTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.icon=[[UIImageView alloc]init];
        [self.contentView addSubview: self.icon];
        
        self.messageTextView =[[CrossMessageTextView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.messageTextView];
    }
    return self;
}

- (void)setMessageFrame:(CrossMessageFrame *)messageFrame
{
    
    _messageFrame = messageFrame;
    
    CrossMessage * message = messageFrame.message;
    
    self.icon.frame = messageFrame.iconRect;
    self.icon.image = messageFrame.avatarImage;
    
    self.icon.layer.cornerRadius = 8;
    self.icon.layer.masksToBounds = YES;
    
    self.messageTextView.message = message;
    self.messageTextView.frame = messageFrame.textViewRect;
    
    if (message.type == CrossMessageText)
    {
        self.messageTextView.textLabel.text = message.text;
    }
    
    else if (message.type == CrossMessageImage)
    {
        self.messageTextView.imageView.layer.cornerRadius = 8;
        self.messageTextView.imageView.layer.masksToBounds = YES;
        self.messageTextView.imageView.image =[UIImage imageWithData:message.data];
    }
    
    [self setBackGroundImageViewImage:self.messageTextView fromImage:@"chatfrom_bg_normal.png" toImage:@"chatto_bg_normal.png"];
}

//set back ground image view
-(void)setBackGroundImageViewImage:(CrossMessageTextView *)messageTextView fromImage:(NSString *)from toImage:(NSString *)to
{
    UIImage *normal = nil;
    
    if([messageTextView.message.incoming intValue] == 1)
    {
        normal = [UIImage imageNamed:from];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        
    }
    else if([messageTextView.message.incoming intValue] == 0)
    {
        normal = [UIImage imageNamed:to];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
    }
    messageTextView.backImageView.image = normal;
}
@end
