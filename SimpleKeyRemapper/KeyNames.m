//
//  KeyNames.m
//  SimpleKeyRemapper
//
//  Created by James on 07/05/2015.
//  Copyright (c) 2015 James Alvarez. All rights reserved.
//

#import "KeyNames.h"
#include <ApplicationServices/ApplicationServices.h>
#include <Carbon/Carbon.h> /* For kVK_ constants, and TIS functions. */

@implementation KeyNames

+ (NSString*)createStringForKey:(CGKeyCode)keyCode {
    TISInputSourceRef currentKeyboard = TISCopyCurrentKeyboardInputSource();
    CFDataRef layoutData =
    TISGetInputSourceProperty(currentKeyboard,
                              kTISPropertyUnicodeKeyLayoutData);
    const UCKeyboardLayout *keyboardLayout =
    (const UCKeyboardLayout *)CFDataGetBytePtr(layoutData);
    
    UInt32 keysDown = 0;
    UniChar chars[4];
    UniCharCount realLength;
    
    UCKeyTranslate(keyboardLayout,
                   keyCode,
                   kUCKeyActionDisplay,
                   0,
                   LMGetKbdType(),
                   kUCKeyTranslateNoDeadKeysBit,
                   &keysDown,
                   sizeof(chars) / sizeof(chars[0]),
                   &realLength,
                   chars);
    CFRelease(currentKeyboard);
    CFStringRef str = CFStringCreateWithCharacters(kCFAllocatorDefault, chars, 1);
    
    NSString *aNSString = (__bridge NSString *)str;
    CFRelease(str);
    return aNSString;
}
@end
