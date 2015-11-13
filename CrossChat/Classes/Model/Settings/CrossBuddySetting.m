//
//  CrossBuddySetting.m
//  CrossChat
//
//  Created by chaobai on 15/10/29.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossBuddySetting.h"
#import "CrossMessageViewController.h"

@implementation CrossBuddySetting

- (id) initWithBuddy:(CrossBuddy*)buddy Title:(NSString *)newTitle description:(NSString *)newDescription
{
    self = [super initWithTitle:newTitle description:newDescription viewControllerClass:[CrossMessageViewController class]];
    
    self.buddy = buddy;
    self.image = buddy.avatarImage;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return self;
}

- (id)initWithTitle:(NSString *)newTitle description:(NSString *)newDescription {
    
    //0. it will show CrossCertificateDomainViewController while click CrossCertificate setting Item
    self = [super initWithTitle:newTitle description:newDescription viewControllerClass:[CrossMessageViewController class]];
    return self;
}

@end
