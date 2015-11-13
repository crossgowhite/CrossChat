//
//  CrossConstants.m
//  CrossChat
//
//  Created by chaobai on 15/9/28.
//  Copyright (c) 2015年 chaobai. All rights reserved.
//

#import "CrossConstants.h"


const NSString * const CrossXMPPResource                                    = @"CrossChat";
const NSString * const CrossXMPPImageName                                   = @"xmpp.png";
const NSString * const CrossYapDatabaseName                                 = @"CrossChatYap.sqlite";

const NSString * const CrossXMPPErrorDomain                                 = @"Cross XMPP Error Domain";
const NSString * const CrossXMPPXMLErrorKey                                 = @"XMPPXMLErrorKey.";
const NSString * const CrossXMMPErrorAlreadyConnectedOrConneting             = @"Attempting to connect while already connected or connecting.";
const NSString * const CrossXMPPErrorP2PStream                               = @"P2P streams must use either connectTo:withAddress: or connectP2PWithSocket:.";
const NSString * const CrossXMPPErrorNoneJIDWhileConnect                     = @"You must set myJID before calling connect.";
const NSString * const CrossXMPPErrorDonotSupportInBandRegistration          = @"The server does not support in band registration.";
const NSString * const CrossXMPPErrorNoneJIDWhileRegisterWithPassword        = @"You must set myJID before calling registerWithPassword:error:.";
const NSString * const CrossXMPPErrorWaitStreamConnected                     = @"Please wait until the stream is connected.";
const NSString * const CrossXMPPErrorNoneJIDWhileAuth                        = @"You must set myJID before calling authenticate:error:.";
const NSString * const CrossXMPPErrorNoSuitableAuthMethod                    = @"No suitable authentication method found";

const NSString * const CrossYapBuddyDatabaseName                             = @"CrossBuddy.sqlite";

const NSString * const CrossMessageDatabaseExtension                         = @".plist";

const NSString *const  CrossMessageViewWillLoad                              = @"CrossMessageViewWillLoad";
const NSString *const  CrossMessageViewDidUnload                             = @"CrossMessageViewDidUnload";