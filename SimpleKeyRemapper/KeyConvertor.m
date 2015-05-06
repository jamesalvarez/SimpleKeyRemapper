//The MIT License (MIT)
//
//Copyright (c) 2015 James Alvarez
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.


#import "KeyConvertor.h"
#import "SimpleKeyRemapper-Swift.h"

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif

@implementation KeyConvertor

- (CGEventRef)copyOrModifyKeyboardEvent:(CGEventRef)event {
    
    // The incoming keycode.
    CGKeyCode keycode = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
    CGEventFlags flags = CGEventGetFlags(event);
    
    // Block sucks up all key events
    if (_monitorKeyBlock != nil) {
        _monitorKeyBlock(flags,keycode);
        return nil;
    }
    
    if (!_mappingKeysMode) {
        return event;
    }
    
    NSLog(@"INTERCEPTING KEY:%d FLAGS:%llu",keycode,flags);
    
    for (id object in _mappings) {
        KeyMapping *keyMapping = (KeyMapping*)object;
        
        CGKeyCode inputKeycode = [[keyMapping inputKey] keyCode];
        CGEventFlags inputFlags = [[keyMapping inputKey] eventFlags];
        
        NSLog(@"CHECKING KEY:%d FLAGS:%llu",inputKeycode,inputFlags);
        if (inputKeycode == keycode && inputFlags == flags) {
            
            CGKeyCode newKeycode = [[keyMapping outputKey] keyCode];
            CGEventFlags newFlags = [[keyMapping outputKey] eventFlags];

            CGEventSetIntegerValueField(event, kCGKeyboardEventKeycode, (int64_t)newKeycode);
            CGEventSetFlags(event, newFlags);
            
            NSLog(@"KEY CONVERTED FROM %d to %d",keycode, newKeycode);
            
            return event;
        }
    }
    
    NSLog(@"KEY NOT CONVERTED");
    return event;
}

- (BOOL)setupInputDeviceListener
{
    CFMachPortRef      eventTap;
    CGEventMask        eventMask;
    CFRunLoopSourceRef runLoopSource;
    
    // Create an event tap. We are interested in key presses.
    eventMask = ((1 << kCGEventKeyDown) | (1 << kCGEventKeyUp));
    eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0,
                                eventMask, myCGEventCallback, (__bridge void *)(self));
    if (!eventTap) {
        NSLog(@"Could not create event tap");
        return NO;
    }
    
    // Create a run loop source.
    runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    
    // Add to the current run loop.
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    
    // Enable the event tap.
    CGEventTapEnable(eventTap, true);
    
    return YES;
}


CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
    // Paranoid sanity check.
    if ((type != kCGEventKeyDown) && (type != kCGEventKeyUp))
        return event;
    
    // Send events to KeyConverter object
    KeyConvertor *kc = (__bridge KeyConvertor*)refcon;
    return [kc copyOrModifyKeyboardEvent: event];
}

@end
