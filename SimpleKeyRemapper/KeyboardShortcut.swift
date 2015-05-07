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


import Foundation
import Cocoa

// Stores eventFlags and keyCode from CGEventRef
@objc class KeyboardShortcut : NSObject , Hashable,Equatable {
    
    //MARK: Vars
    
    var eventFlags : CGEventFlags
    var keyCode : CGKeyCode
    
    //MARK: Inits
    
    override init() {
        self.keyCode = 0
        self.eventFlags = 0
        super.init()
    }
    
    init(keyCode: CGKeyCode, eventFlags : CGEventFlags) {
        self.keyCode = keyCode
        self.eventFlags = eventFlags
        super.init()
    }
    
    init?(dictionary : [NSObject : AnyObject]) {
        if let keyCodeInt = dictionary["keyCodes"] as? Int,
            eventFlagsInt = dictionary["modifierCodes"] as? Int {
                self.eventFlags = CGEventFlags(eventFlagsInt)
                self.keyCode = CGKeyCode(keyCodeInt)
                super.init()
        } else {
            self.keyCode = 0
            self.eventFlags = 0
            super.init()
            return nil
        }
    }
    
    //MARK: Saving
    
    func toDictionary() -> [NSObject : AnyObject] {
        var dic : [NSObject : AnyObject] = [:]
        dic["keyCodes"] = Int(keyCode)
        dic["modifierCodes"] = Int(eventFlags)
        return dic
    }
    
    //MARK: Equatable
    
    override var hashValue : Int {
        get {
            return "\(eventFlags):\(keyCode)".hashValue
        }
    }
    
    //MARK: Display
    
    var stringValue : String {
        return KeyStringFromKeyCode(keyCode,eventFlags)
    }
    
}

//MARK: Equatable

func ==(lhs: KeyboardShortcut, rhs: KeyboardShortcut) -> Bool {
    return (lhs.hashValue == rhs.hashValue)
}

//MARK: Displaying

// Some code by Bill Stevenson translated from: http://ritter.ist.psu.edu/projects/RUI/macosx/rui.c

func KeyStringFromKeyCode(keyCode : CGKeyCode, flags : CGEventFlags) -> String
{
    var flagString : String = ""
    var key : String = KeyNames.createStringForKey(keyCode)
    
    if (Int(flags) & kCGEventFlagMaskCommand) == kCGEventFlagMaskCommand {
        flagString += "⌘ "
    }
    
    if (Int(flags) & kCGEventFlagMaskShift) == kCGEventFlagMaskShift {
        flagString += "⇧ "
    }
    
    if (Int(flags) & kCGEventFlagMaskControl) == kCGEventFlagMaskControl {
        flagString += "⌃ "
    }
    
    if (Int(flags) & kCGEventFlagMaskAlternate) == kCGEventFlagMaskAlternate {
        flagString += "⌥ "
    }
    
    if (Int(flags) & kCGEventFlagMaskSecondaryFn) == kCGEventFlagMaskSecondaryFn {
        flagString += "FN "
    }
    
    if flagString != "" { flagString += "+ " }
    
    
    return flagString+key
}



