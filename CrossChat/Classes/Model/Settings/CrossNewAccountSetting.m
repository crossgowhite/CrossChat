//
//  CrossNewAccountSetting.m
//  CrossChat
//
//  Created by chaobai on 15/9/22.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossNewAccountSetting.h"
#import "CrossAlertViewController.h"

@implementation CrossNewAccountSetting

- (id)initWithTitle:(NSString *)newTitle description:(NSString *)newDescription {
    
    //0. it will show CrossCertificateDomainViewController while click CrossCertificate setting Item
    self = [super initWithTitle:newTitle description:newDescription viewControllerClass:[CrossAlertViewController class]];
    self.image = [UIImage imageNamed:@"31-circle-plus"];
//    self.imageName = @"31-circle-plus";
    return self;
}

@end
