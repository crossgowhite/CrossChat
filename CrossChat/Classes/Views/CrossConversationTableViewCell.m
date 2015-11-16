//
//  CrossConversationTableViewCell.m
//  CrossChat
//
//  Created by chaobai on 15/11/6.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossConversationTableViewCell.h"
#import "CrossConversationSetting.h"
#import "CrossBuddy.h"

@implementation CrossConversationTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setSetting:(CrossSetting *)setting
{
    CrossConversationSetting * conversationSetting = setting;
    
    self.textLabel.text = conversationSetting.buddy.displayName;
    
    if (conversationSetting.buddy.statusMessage != nil)
    {
        self.detailTextLabel.text = conversationSetting.buddy.statusMessage;
    }
    
    if (conversationSetting.buddy.avatarData)
    {
        self.imageView.image = [UIImage imageWithData:conversationSetting.buddy.avatarData];
        self.imageView.layer.cornerRadius = 8;
        self.imageView.layer.masksToBounds = YES;
    }
    self.accessoryType = conversationSetting.accessoryType;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10,10,30,30);
    [self.imageView setAutoresizingMask:UIViewAutoresizingNone];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 50;
    self.textLabel.frame = frame;
    
    frame = self.detailTextLabel.frame;
    frame.origin.x = 50;
    self.detailTextLabel.frame = frame;
}


@end
