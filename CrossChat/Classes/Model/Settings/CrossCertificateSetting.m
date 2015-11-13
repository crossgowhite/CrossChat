//
//  CrossCertificateSetting.m
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossCertificateSetting.h"
#import "CrossCertificateDomainViewController.h"

@implementation CrossCertificateSetting

- (id)initWithTitle:(NSString *)newTitle description:(NSString *)newDescription {
    
    //0. it will show CrossCertificateDomainViewController while click CrossCertificate setting Item
    self = [super initWithTitle:newTitle description:newDescription viewControllerClass:[CrossCertificateDomainViewController class]];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return self;
}

@end
