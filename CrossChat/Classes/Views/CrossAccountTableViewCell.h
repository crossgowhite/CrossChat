//
//  CrossAccountTableViewCell.h
//  CrossChat
//
//  Created by chaobai on 15/9/22.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrossSetting.h"

@interface CrossAccountTableViewCell : UITableViewCell

- (void) setSetting:(CrossSetting *)setting;

- (NSString *) getTextFiledString;
- (void) setTextfieldWithValue: (NSString *)newString;

- (BOOL) getAutoLogin;
- (void) setAutoLogin :(BOOL)autoFlag;

@end
