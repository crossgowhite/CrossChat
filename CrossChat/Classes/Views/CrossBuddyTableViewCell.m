//
//  CrossBuddyTableViewCell.m
//  CrossChat
//
//  Created by chaobai on 15/10/29.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossBuddyTableViewCell.h"
#import "CrossSetting.h"
#import "CrossBuddySetting.h"

@interface CrossBuddyTableViewCell ()

@end
@implementation CrossBuddyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setSetting:(CrossSetting *)setting
{
    CrossBuddySetting * buddySetting = setting;
    
    self.textLabel.text = buddySetting.buddy.displayName;
    
    if (buddySetting.buddy.avatarData)
    {
        self.imageView.image = [UIImage imageWithData:buddySetting.buddy.avatarData];
        self.imageView.layer.cornerRadius = 8;
        self.imageView.layer.masksToBounds = YES;
    }
    self.accessoryType = buddySetting.accessoryType;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10,10,30,30);
    [self.imageView setAutoresizingMask:UIViewAutoresizingNone];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 50;
    self.textLabel.frame = frame;
    
    
}
@end
