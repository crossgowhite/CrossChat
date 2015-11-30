//
//  CrossConstants.h
//  CrossChat
//
//  Created by chaobai on 15/9/24.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#ifndef CROSS_CONSTANTS_H
#define CROSS_CONSTANTS_H

#import <Foundation/Foundation.h>

static NSString * const CrossXMPPResource                                    = @"CrossChat";
static NSString * const CrossXMPPImageName                                   = @"xmpp.png";
static NSString * const CrossYapDatabaseName                                 = @"CrossChatYap.sqlite";

static NSString * const CrossXMPPErrorDomain                                 = @"Cross XMPP Error Domain";
static NSString * const CrossXMPPXMLErrorKey                                 = @"XMPPXMLErrorKey.";
static NSString * const CrossXMMPErrorAlreadyConnectedOrConneting             = @"Attempting to connect while already connected or connecting.";
static NSString * const CrossXMPPErrorP2PStream                               = @"P2P streams must use either connectTo:withAddress: or connectP2PWithSocket:.";
static NSString * const CrossXMPPErrorNoneJIDWhileConnect                     = @"You must set myJID before calling connect.";
static NSString * const CrossXMPPErrorDonotSupportInBandRegistration          = @"The server does not support in band registration.";
static NSString * const CrossXMPPErrorNoneJIDWhileRegisterWithPassword        = @"You must set myJID before calling registerWithPassword:error:.";
static NSString * const CrossXMPPErrorWaitStreamConnected                     = @"Please wait until the stream is connected.";
static NSString * const CrossXMPPErrorNoneJIDWhileAuth                        = @"You must set myJID before calling authenticate:error:.";
static NSString * const CrossXMPPErrorNoSuitableAuthMethod                    = @"No suitable authentication method found";

static NSString * const CrossYapBuddyDatabaseName                             = @"CrossBuddy.sqlite";

static NSString * const CrossMessageDatabaseExtension                         = @".plist";

static NSString * const  CrossMessageViewWillLoad                             = @"CrossMessageViewWillLoad";
static NSString * const  CrossMessageViewDidUnload                            = @"CrossMessageViewDidUnload";

static NSString * const  CrossMessageReceived                                 = @"CrossMessageReceivedNotification";

static NSString * const  CrossMesssageType                                    = @"CrossMessageType";
static NSString * const  CrossMessageTextType                                 = @"CrossMessageTextType";
static NSString * const  CrossMessageImageType                                = @"CrossMessageImageType";


#endif