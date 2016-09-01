//
//  MainViewController+KeyboardListener.m
//  KeyboardListener
//
//  Created by Greg Shutt on 9/1/16.
//
//

#import "MainViewController+KeyboardListener.h"
#import "KeyboardListener.h"

@implementation MainViewController (KeyboardListener)

// the view controller must be first responder to receive any key press events
- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) onKeyPress: (UIKeyCommand *) keyCommand {
    [KeyboardListener onKeyPress:[keyCommand input]];
}

- (NSArray*) keyCommands {
    return([KeyboardListener keyCommands]);
}

@end
