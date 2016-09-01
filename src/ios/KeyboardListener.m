//
//  KeyboardListener.m
//  keyboard-listener plugin
//
//  Created by Greg Shutt on 9/1/16.
//
//

#import "KeyboardListener.h"

@implementation KeyboardListener

static NSMutableArray* callbacks = nil;

-(void)cordovaRegister:(CDVInvokedUrlCommand*)command
{
    if(callbacks == nil) {
        callbacks = [[NSMutableArray alloc] init];
    }
    
    
    // watch for keypress events
    NSString* callbackId = command.callbackId;
    id<CDVCommandDelegate> delegate = self.commandDelegate;
    
    [callbacks addObject:[NSDictionary dictionaryWithObjectsAndKeys:callbackId, @"callbackId",
                          delegate, @"commandDelegate", nil]];
    
    CDVPluginResult *pluginResult = [CDVPluginResult
                                     resultWithStatus:CDVCommandStatus_OK
                                     messageAsString:@""];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [delegate sendPluginResult:pluginResult callbackId:callbackId];
    
    NSLog(@"Registered for keyboard events");
}

+(void)onKeyPress:(NSString*) key
{
    for(id dict in callbacks) {
        NSString* callbackId = [dict objectForKey:@"callbackId"];
        id<CDVCommandDelegate> delegate = [dict objectForKey:@"commandDelegate"];
        
        CDVPluginResult *result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsString:key];
        [result setKeepCallback:[NSNumber numberWithBool:YES]];
        [delegate sendPluginResult:result callbackId:callbackId];
    }
    
    NSLog(@"Caught %@", key);
}

+(NSArray*)keyCommands
{
    return([[NSArray alloc] initWithObjects:
            // command keys
            [UIKeyCommand keyCommandWithInput:@"\r" modifierFlags:0 action:@selector(onKeyPress:)],
            
            // lowercase
            [UIKeyCommand keyCommandWithInput:@"a" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"b" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"c" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"d" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"e" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"f" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"g" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"h" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"i" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"j" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"k" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"l" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"m" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"n" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"o" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"p" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"q" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"r" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"s" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"t" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"u" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"v" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"w" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"x" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"y" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"z" modifierFlags:0 action:@selector(onKeyPress:)],
            
            // capital letters
            [UIKeyCommand keyCommandWithInput:@"A" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"B" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"C" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"D" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"E" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"F" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"G" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"H" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"I" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"J" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"K" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"L" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"M" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"N" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"O" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"P" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"Q" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"R" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"S" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"T" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"U" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"V" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"W" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"X" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"Y" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"Z" modifierFlags:UIKeyModifierShift action:@selector(onKeyPress:)],
            
            // numbers
            [UIKeyCommand keyCommandWithInput:@"1" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"2" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"3" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"4" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"5" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"6" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"7" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"8" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"9" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"0" modifierFlags:0 action:@selector(onKeyPress:)],
            
            // special characters
            [UIKeyCommand keyCommandWithInput:@"`" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"~" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"!" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"@" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"#" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"$" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"%" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"^" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"&" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"*" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"(" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@")" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"-" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"_" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"=" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"+" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"[" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"{" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"]" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"}" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"\\" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"|" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@";" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@":" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"'" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"\"" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"," modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"<" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"." modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@">" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"/" modifierFlags:0 action:@selector(onKeyPress:)],
            [UIKeyCommand keyCommandWithInput:@"?" modifierFlags:0 action:@selector(onKeyPress:)],
            
            nil]);
}

@end
