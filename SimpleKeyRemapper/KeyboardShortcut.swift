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

//MARK: Disaplying

func KeyStringFromKeyCode(keyCode : CGKeyCode, flags : CGEventFlags) -> String
{
    var flagString : String = ""
    var key : String = ""
    
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
    

    switch (keyCode)
    {
        case 0: key = "a"
        case 1: key = "s"
        case 2: key = "d"
        case 3: key = "f"
        case 4: key = "h"
        case 5: key = "g"
        case 6: key = "z"
        case 7: key = "x"
        case 8: key = "c"
        case 9: key = "v"
        case 11: key = "b"
        case 12: key = "q"
        case 13: key = "w"
        case 14: key = "e"
        case 15: key = "r"
        case 16: key = "y"
        case 17: key = "t"
        case 18: key = "1"
        case 19: key = "2"
        case 20: key = "3"
        case 21: key = "4"
        case 22: key = "6"
        case 23: key = "5"
        case 24: key = "="
        case 25: key = "9"
        case 26: key = "7"
        case 27: key = "-"
        case 28: key = "8"
        case 29: key = "0"
        case 30: key = "]"
        case 31: key = "o"
        case 32: key = "u"
        case 33: key = "["
        case 34: key = "i"
        case 35: key = "p"
        case 36: key = "RETURN"
        case 37: key = "l"
        case 38: key = "j"
        case 39: key = "'"
        case 40: key = "k"
        case 41: key = ""
        case 42: key = "\\"
        case 43: key = ","
        case 44: key = "/"
        case 45: key = "n"
        case 46: key = "m"
        case 47: key = "."
        case 48: key = "TAB"
        case 49: key = "SPACE"
        case 50: key = "`"
        case 51: key = "DELETE"
        case 52: key = "ENTER"
        case 53: key = "ESCAPE"
        case 65: key = "."
        case 67: key = "*"
        case 69: key = "+"
        case 71: key = "CLEAR"
        case 75: key = "/"
        case 76: key = "ENTER"   // numberpad on full kbd
        case 78: key = "-"
        case 81: key = "="
        case 82: key = "0"
        case 83: key = "1"
        case 84: key = "2"
        case 85: key = "3"
        case 86: key = "4"
        case 87: key = "5"
        case 88: key = "6"
        case 89: key = "7"
        case 91: key = "8"
        case 92: key = "9"
        case 96: key = "F5"
        case 97: key = "F6"
        case 98: key = "F7"
        case 99: key = "F3"
        case 100: key = "F8"
        case 101: key = "F9"
        case 103: key = "F11"
        case 105: key = "F13"
        case 107: key = "F14"
        case 109: key = "F10"
        case 111: key = "F12"
        case 113: key = "F15"
        case 114: key = "HELP"
        case 115: key = "HOME"
        case 116: key = "PGUP"
        case 117: key = "DELETE"
        case 118: key = "F4"
        case 119: key = "END"
        case 120: key = "F2"
        case 121: key = "PGDN"
        case 122: key = "F1"
        case 123: key = "LEFT"
        case 124: key = "RIGHT"
        case 125: key = "DOWN"
        case 126: key = "UP"
        default: key = "Unknown key"
    }
    
    return flagString+key
}

