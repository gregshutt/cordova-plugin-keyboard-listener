//
//  KeyboardListener.h
//  keyboardlistenertest
//
//  Created by Greg Shutt on 12/9/13.
//
//

#import <Cordova/CDV.h>

@interface KeyboardListener : CDVPlugin

    @property (nonatomic, retain) NSString* callbackId;
    
    -(void)cordovaRegister:(CDVInvokedUrlCommand*)command;

    
@end
