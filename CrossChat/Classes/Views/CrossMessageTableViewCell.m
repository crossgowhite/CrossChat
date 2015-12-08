//
//  CrossMessageTableViewCell.m
//  CrossChat
//
//  Created by chaobai on 15/11/3.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossMessageTableViewCell.h"
#import "CrossMessageTextView.h"
#import "CrossMessageFrame.h"
#import "CrossMessage.h"

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface CrossMessageTableViewCell ()

@property (nonatomic,strong) UIImageView *icon;

//chart content view, no include icon
@property (nonatomic,strong) CrossMessageTextView *messageTextView;


@end
@implementation CrossMessageTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.icon=[[UIImageView alloc]init];
        [self.contentView addSubview: self.icon];
        
        self.messageTextView =[[CrossMessageTextView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.messageTextView];
    }
    return self;
}

- (void)setMessageFrame:(CrossMessageFrame *)messageFrame
{
    
    _messageFrame = messageFrame;
    
    CrossMessage * message = messageFrame.message;
    
    self.icon.frame = messageFrame.iconRect;
    self.icon.image = messageFrame.avatarImage;
    
    self.icon.layer.cornerRadius = 8;
    self.icon.layer.masksToBounds = YES;
    
    self.messageTextView.message = message;
    self.messageTextView.frame = messageFrame.textViewRect;
    
    if (message.type == CrossMessageText)
    {
        self.messageTextView.textLabel.text = message.text;
    }
    
    else if (message.type == CrossMessageImage)
    {
        
        self.messageTextView.textLabel.text = nil;
        self.messageTextView.imageView.layer.cornerRadius = 8;
        self.messageTextView.imageView.layer.masksToBounds = YES;
        
        __block NSData * data = nil;
        
        //local image, use url rather than nsdata, inorder to save the disk content
        if ([message.incoming intValue] == 0)
        {
            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            [assetLibrary assetForURL:[NSURL URLWithString:message.dataURL]
                          resultBlock:^(ALAsset *asset){
                              ALAssetRepresentation *rep = [asset defaultRepresentation];
                              Byte *buffer = (Byte*)malloc(rep.size);
                              NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
                              data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                              self.messageTextView.imageView.image =[UIImage imageWithData:data];
                          }
                         failureBlock:^(NSError *error) {}
             ];
        }
        
        else if([message.incoming intValue] == 1)
        {
            self.messageTextView.imageView.image =[UIImage imageWithData:message.data];
        }
        
        if ([message.successSend intValue] == 0)
        {
            [self.messageTextView.indicator startAnimating];
        }
        else
        {
            [self.messageTextView.indicator stopAnimating];
        }
    }
    
    [self setBackGroundImageViewImage:self.messageTextView fromImage:@"chatfrom_bg_normal.png" toImage:@"chatto_bg_normal.png"];
}

//set back ground image view
-(void)setBackGroundImageViewImage:(CrossMessageTextView *)messageTextView fromImage:(NSString *)from toImage:(NSString *)to
{
    UIImage *normal = nil;
    
    if([messageTextView.message.incoming intValue] == 1)
    {
        normal = [UIImage imageNamed:from];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        
    }
    else if([messageTextView.message.incoming intValue] == 0)
    {
        normal = [UIImage imageNamed:to];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
    }
    messageTextView.backImageView.image = normal;
}
@end
