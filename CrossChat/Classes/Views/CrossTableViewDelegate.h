//
//  CrossTableViewDelegate.h
//  CrossChat
//
//  Created by chaobai on 15/11/16.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CrossViewManager;

@interface CrossTableViewDelegate : NSObject  <UITableViewDelegate>

- (id)initWithViewManager:(CrossViewManager *)manager;
@end
