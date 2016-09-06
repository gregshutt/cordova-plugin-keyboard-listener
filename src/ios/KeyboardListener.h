//
//  KeyboardListener.m
//  keyboard-listener plugin
//
//  Created by Greg Shutt on 9/1/16.
//
//

#import <Cordova/CDVPlugin.h>

@interface KeyboardListener : CDVPlugin

-(void)cordovaRegister:(CDVInvokedUrlCommand*)command;
+(void)onKeyPress:(NSString*)key;
+(NSArray*)keyCommands;

@end
