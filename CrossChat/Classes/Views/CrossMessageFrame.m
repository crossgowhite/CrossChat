//
//  CrossMessageFrame.m
//  CrossChat
//
//  Created by chaobai on 15/11/3.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossMessageFrame.h"
#import "CrossMessage.h"


#define kIconMarginX 5
#define kIconMarginY 5

#define IconWidth 40
#define IconHeight 40

#define IMAGEWIDTH 100
#define IMAGEHEIGHT 120
@implementation CrossMessageFrame

- (void)setMessage:(CrossMessage *)message
{
    _message = message;
    
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat iconX = kIconMarginX;
    CGFloat iconY = kIconMarginY;
    
    CGFloat iconWidth = IconWidth;
    CGFloat iconHeight = IconHeight;
    
    if ([message.incoming intValue] == 0)
        iconX = winSize.width - kIconMarginX - iconWidth;

    self.iconRect = CGRectMake(iconX, iconY, iconWidth, iconHeight);
    
    CGFloat contentX = CGRectGetMaxX(self.iconRect) + kIconMarginX;
    CGFloat contentY = iconY;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]};
    
    CGSize contentSize;
    
    if (message.type == CrossMessageText)
    {
        contentSize = [message.text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    }
    else if(message.type == CrossMessageImage)
    {
        contentSize = CGSizeMake(IMAGEWIDTH,IMAGEHEIGHT);
    }

    
    if ([message.incoming intValue] == 0)
        contentX = iconX - kIconMarginX - contentSize.width - iconWidth;
    
    self.textViewRect = CGRectMake(contentX, contentY, contentSize.width+35, contentSize.height+30);
    
    self.messageHeight = MAX(CGRectGetMaxY(self.iconRect), CGRectGetMaxY(self.textViewRect))+kIconMarginX;
}
@end
