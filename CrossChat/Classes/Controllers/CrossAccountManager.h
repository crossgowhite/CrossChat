//
//  CrossAccountManager.h
//  CrossChat
//
//  Created by chaobai on 15/10/20.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CrossAccount;

@interface CrossAccountManager : NSObject


+ (CrossAccount*) connectedAccount;

@end
