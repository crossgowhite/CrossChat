//
//  CrossAccountSetting.m
//  CrossChat
//
//  Created by chaobai on 15/9/29.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossAccountSetting.h"
#import "CrossNewAccountViewController.h"

@implementation CrossAccountSetting

- (id)initWithTitle:(NSString *)newTitle description:(NSString *)newDescription {
    
    //0. it will show CrossCertificateDomainViewController while click CrossCertificate setting Item
    self = [super initWithTitle:newTitle description:newDescription viewControllerClass:[CrossNewAccountViewController class]];
    self.image = [UIImage imageNamed:@"xmpp"];
    return self;
}

- (void)setAccount:(CrossAccount *)account
{
    _account = account;
    if (self.account.avatarImageData)
    {
        self.image = [UIImage imageWithData:self.account.avatarImageData];
    }
}

@end
