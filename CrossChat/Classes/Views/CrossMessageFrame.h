//
//  CrossMessageFrame.h
//  CrossChat
//
//  Created by chaobai on 15/11/3.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CrossMessage;

@interface CrossMessageFrame : NSObject

//icon size
@property (nonatomic, assign) CGRect iconRect;

//messages label size
@property (nonatomic, assign) CGRect textViewRect;

//message info
@property (nonatomic, strong) CrossMessage * message;

//message height
@property (nonatomic, assign) CGFloat messageHeight;

//icon image
@property (nonatomic, strong) UIImage * avatarImage;

@end
