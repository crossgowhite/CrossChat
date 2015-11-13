//
//  CrossSettingTableViewCell.m
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossSettingTableViewCell.h"
#import "CrossViewSetting.h"


@implementation CrossSettingTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setSetting:(CrossSetting *)setting
{
    //self.setting = setting;
    
    self.textLabel.text = setting.title;
    self.detailTextLabel.text = setting.settingDescription;
    
    if (setting.image)
    {
        self.imageView.image = setting.image;
        self.imageView.layer.cornerRadius = 8;
        self.imageView.layer.masksToBounds = YES;
    }
//    if(setting.imageName)
//    {
//        self.imageView.image = [UIImage imageNamed:setting.imageName];
//    }
//    
//    else
//    {
//        self.imageView.image = nil;
//    }
    
    UIView * accessoryView = nil;
    
    //0. CrossView Style Setting
    //   Style: accessory
    if([setting isKindOfClass:[CrossViewSetting class]])
    {
        self.accessoryType = ((CrossViewSetting *)setting).accessoryType;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    
    self.accessoryView = accessoryView;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10,10,30,30);
    [self.imageView setAutoresizingMask:UIViewAutoresizingNone];
}
@end
