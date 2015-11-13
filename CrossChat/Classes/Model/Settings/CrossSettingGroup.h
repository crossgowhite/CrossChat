//
//  CrossSettingGroup.h
//  CrossChat
//
//  Created by chaobai on 15/9/21.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrossSettingGroup : NSObject

@property (nonatomic, retain) NSArray *   settings;
@property (nonatomic, retain, readonly) NSString *  title;

- (id) initWithTitle:(NSString*)newTitle settings:(NSArray*)newSettings;

@end
