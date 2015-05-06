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

// Stores two KeyboardShortcuts, provides methods for saving and creating from dictionaries
@objc class KeyMapping : NSObject {
    
    //MARK: Init
    
    init(inputKey : KeyboardShortcut, outputKey : KeyboardShortcut) {
        self.inputKey = inputKey
        self.outputKey = outputKey
        super.init()
    }
    
    override init() {
        inputKey = KeyboardShortcut()
        outputKey = KeyboardShortcut()
        super.init()
    }
    
    init?(dictionary : [NSObject : AnyObject]) {
        if let inputKeyDic = dictionary["inputKey"] as? [NSObject : AnyObject],
            inputKey = KeyboardShortcut(dictionary: inputKeyDic),
            outputKeyDic = dictionary["outputKey"] as? [NSObject : AnyObject],
            outputKey = KeyboardShortcut(dictionary: outputKeyDic) {
                self.inputKey = inputKey
                self.outputKey = outputKey
                super.init()
        } else {
            inputKey = KeyboardShortcut()
            outputKey = KeyboardShortcut()
            super.init()
            return nil
        }
    }
    
    //MARK: Saving
    
    func toDictionary() -> [NSObject : AnyObject] {
        var dic : [NSObject : AnyObject] = [:]
        dic["inputKey"] = inputKey.toDictionary()
        dic["outputKey"] = outputKey.toDictionary()
        return dic
    }
    
    //MARK: Shortcut vars
    
    var inputKey : KeyboardShortcut
    var outputKey  : KeyboardShortcut
}