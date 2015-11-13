//
//  CrossAccountTableViewCell.m
//  CrossChat
//
//  Created by chaobai on 15/9/22.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossAccountTableViewCell.h"
#import "String.h"
@interface CrossAccountTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UISwitch *switchbutton;

@end


@implementation CrossAccountTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setSetting:(CrossSetting *)setting
{
    self.label.text = setting.title;
    if(setting.title == AUTO_LOGIN_STRING)
    {
        self.textfield.hidden = YES;
        self.switchbutton.hidden = NO;
    }
    self.textfield.placeholder = setting.title;
    if(setting.title == PASSWORD_STRING)
        self.textfield.secureTextEntry = YES;

}

- (NSString *) getTextFiledString
{
    return self.textfield.text;
}

- (BOOL) getAutoLogin
{
    return self.switchbutton.on;
}

- (void) setTextfieldWithValue: (NSString *) newString
{
    self.textfield.text = newString;
}

- (void) setAutoLogin :(BOOL)autoFlag
{
    self.switchbutton.on = autoFlag;
}

@end
