//
//  CrossArrayDataSource.h
//  CrossChat
//
//  Created by chaobai on 15/11/16.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CrossViewManager;

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface CrossArrayDataSource : NSObject<UITableViewDataSource>

- (id)initWithViewManager:(CrossViewManager *)manager cellIdentifier:(NSString *)aCellIdentifier configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock cellClass:(Class)cellClass;

@end
