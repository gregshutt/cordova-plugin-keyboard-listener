//
//  KeyboardListener.m
//  keyboardlistenertest
//
//  Created by Greg Shutt on 12/9/13.
//
//

#import "KeyboardListener.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation KeyboardListener

static NSString *const kGKKeyboardNotification = @"PSPDFKeyboardEventNotification";

-(void)cordovaRegister:(CDVInvokedUrlCommand*)command
{
    // watch for keypress events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyPress:)
                                                 name:kGKKeyboardNotification
                                               object:nil];
    
    self.callbackId = command.callbackId;
    CDVPluginResult *pluginResult = [CDVPluginResult
                                     resultWithStatus:CDVCommandStatus_OK
                                     messageAsString:@""];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
    
    NSLog(@"Registered for keyboard events");
}

-(void)onKeyPress:(NSNotification*) notification
{
    CDVPluginResult *result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[[notification userInfo] objectForKey:@"key"]];
    [result setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
    
    NSLog(@"Caught %@", [[notification userInfo] objectForKey:@"key"]);
}

// Calculation of offsets for traversing GSEventRef:
// Count the size of types inside CGEventRecord struct
// https://github.com/kennytm/iphone-private-frameworks/blob/master/GraphicsServices/GSEvent.h

// typedef struct GSEventRecord {
//        GSEventType type;          // 0x8  //2
//        GSEventSubType subtype;    // 0xC  //3
//        CGPoint location;          // 0x10 //4
//        CGPoint windowLocation;    // 0x18 //6
//        int windowContextId;       // 0x20 //8
//        uint64_t timestamp;        // 0x24, from mach_absolute_time //9
//        GSWindowRef window;        // 0x2C //
//        GSEventFlags flags;        // 0x30 //12
//        unsigned senderPID;        // 0x34 //13
//        CFIndex infoSize;          // 0x38 //14
// } GSEventRecord;

// typedef struct GSEventKey {
//        GSEvent _super;
//        UniChar keycode, characterIgnoringModifier, character;    // 0x38, 0x3A, 0x3C // 15 and start of 16
//        short characterSet;        // 0x3E // end of 16
//        Boolean isKeyRepeating;    // 0x40 // start of 17
// } GSEventKey;

#define GSEVENT_TYPE 2
#define GSEVENT_FLAGS 12
#define GSEVENTKEY_KEYCODE 16
#define GSEVENTKEY_KEYCODE_64_BIT 19
#define GSEVENT_TYPE_KEYUP 10

#define GSEVENT_FLAGS_SHIFT   (1 << 17)
#define GSEVENT_FLAGS_CONTROL (1 << 18)
#define GSEVENT_FLAGS_ALT     (1 << 19)
#define GSEVENT_FLAGS_COMMAND (1 << 20)

__attribute__((constructor)) static void addKeyboardSupport(void) {
    
    if (sizeof(NSUInteger) == 8) {
        // do stuff
    }
    
    @autoreleasepool {
        // Hook into sendEvent: to get keyboard events.
        SEL sendEventSEL = NSSelectorFromString(@"pspdf_sendEvent:");
        IMP sendEventIMP = imp_implementationWithBlock(^(id _self, UIEvent *event) {
            objc_msgSend(_self, sendEventSEL, event); // call original implementation.
            
            SEL gsEventSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@Event", @"_", @"gs"]);
            if ([event respondsToSelector:gsEventSEL]) {
                // Key events come in form of UIInternalEvents.
                // They contain a GSEvent object which contains a GSEventRecord among other things.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                void *eventVoid = (__bridge void*)[event performSelector:gsEventSEL];
#pragma clang diagnostic pop
                NSInteger *eventMem = (NSInteger *)eventVoid;
                if (eventMem) {
                    if (eventMem[GSEVENT_TYPE] == GSEVENT_TYPE_KEYUP) {
                        
                        NSUInteger idx = sizeof(NSInteger) == 8 ? GSEVENTKEY_KEYCODE_64_BIT : GSEVENTKEY_KEYCODE;
                        NSInteger eventFlags = eventMem[GSEVENT_FLAGS];

                        NSUInteger *highKeycode = (NSUInteger *)&(eventMem[idx]);
                        NSUInteger *lowKeycode = (NSUInteger *)&(eventMem[idx + 1]);
                        
                        NSString* key = _stringFromKeycode(highKeycode, lowKeycode, eventFlags);
                        
                        //NSLog(@"Pressed %@", key);
                        
                        if(key != nil) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kGKKeyboardNotification object:nil userInfo: @{@"key" : key}];
                        }
                    }
                }
            }
        });
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        replaceMethod(UIApplication.class, @selector(handleKeyUIEvent:), sendEventSEL, sendEventIMP);
#pragma clang diagnostic pop
    }
}

static void swizzleMethod(Class c, SEL orig, SEL new) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

static void replaceMethod(Class c, SEL orig, SEL newSel, IMP impl) {
    Method method = class_getInstanceMethod(c, orig);
    if (!class_addMethod(c, newSel, impl, method_getTypeEncoding(method))) {
        NSLog(@"Failed to add method: %@ on %@", NSStringFromSelector(newSel), c);
    } else {
        swizzleMethod(c, orig, newSel);
    }
}

static NSString* _stringFromKeycode(NSUInteger* highByte, NSUInteger* lowByte, NSInteger flags) {
    NSInteger highCode = highByte[0];
    NSInteger lowCode = lowByte[0];
    
    if(highCode == 0) {
        if (lowCode < 29) {
            NSString* key = nil;

            if (lowCode ==  4) key = @"a";
            if (lowCode ==  5) key = @"b";
            if (lowCode ==  6) key = @"c";
            if (lowCode ==  7) key = @"d";
            if (lowCode ==  8) key = @"e";
            if (lowCode ==  9) key = @"f";
            if (lowCode == 10) key = @"g";
            if (lowCode == 11) key = @"h";
            if (lowCode == 12) key = @"i";
            if (lowCode == 13) key = @"j";
            if (lowCode == 14) key = @"k";
            if (lowCode == 15) key = @"l";
            if (lowCode == 16) key = @"m";
            if (lowCode == 17) key = @"n";
            if (lowCode == 18) key = @"o";
            if (lowCode == 19) key = @"p";
            if (lowCode == 20) key = @"q";
            if (lowCode == 21) key = @"r";
            if (lowCode == 22) key = @"s";
            if (lowCode == 23) key = @"t";
            if (lowCode == 24) key = @"u";
            if (lowCode == 25) key = @"v";
            if (lowCode == 26) key = @"w";
            if (lowCode == 27) key = @"x";
            if (lowCode == 28) key = @"y";
            if (lowCode == 29) key = @"z";
            
            if(flags & GSEVENT_FLAGS_SHIFT) {
                return [key uppercaseString];
            }
            return key;
            
        } else {
            if(flags & GSEVENT_FLAGS_SHIFT) {
                if (lowCode==30) return @"!";
                if (lowCode==31) return @"@";
                if (lowCode==32) return @"#";
                if (lowCode==33) return @"$";
                if (lowCode==34) return @"%";
                if (lowCode==35) return @"^";
                if (lowCode==36) return @"&";
                if (lowCode==37) return @"*";
                if (lowCode==38) return @"(";
                if (lowCode==39) return @")";
                if (lowCode==45) return @"_";
                if (lowCode==55) return @">";
            } else {
                if (lowCode==30) return @"1";
                if (lowCode==31) return @"2";
                if (lowCode==32) return @"3";
                if (lowCode==33) return @"4";
                if (lowCode==34) return @"5";
                if (lowCode==35) return @"6";
                if (lowCode==36) return @"7";
                if (lowCode==37) return @"8";
                if (lowCode==38) return @"9";
                if (lowCode==39) return @"0";
                if (lowCode==45) return @"-";
                if (lowCode==55) return @".";
            }
            
//            if (keyCode==43) return ORTabKey;
            if (lowCode==44) return @" ";
//            if (keyCode==53) return ORTildeKey;
//            if (keyCode==42) return ORDeleteKey;
            if (lowCode==40) return @"\n";
//            if (keyCode==41) return OREscapeKey;
            if (lowCode==54) return @",";
            if (lowCode==56) return @"/";
            
            
//            if (keyCode==82) return ORUpKey;
//            if (keyCode==81) return ORDownKey;
//            if (keyCode==80) return ORLeftKey;
//            if (keyCode==79) return ORRightKey;
        }
    }
    NSLog(@"unknown: %d/%d", highCode, lowCode);
    return nil;
}
    
@end
