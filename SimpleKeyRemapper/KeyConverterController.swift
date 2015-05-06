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

class KeyConverterController: NSObject {
    
    //MARK: Outlets
    
    @IBOutlet var onButton : NSButton!
    
    //MARK: Vars
    
    private var keyConvertor : KeyConvertor
    var currentKeyMappings : [KeyMapping]
    
    //MARK: Setup
    
    override init() {
        currentKeyMappings = []
        keyConvertor = KeyConvertor()
        keyConvertor.setupInputDeviceListener()
        super.init()
    }
    
    override func awakeFromNib() {
        loadKeyMappings()
        switchMappingKeysModeOn()
        super.awakeFromNib()
    }
    
    //MARK: Actions
    
    @IBAction func pressButtonOn(AnyObject) {
        if keyConvertor.mappingKeysMode {
            switchMappingKeysModeOff()
        } else {
            switchMappingKeysModeOn()
        }
    }
    
    //MARK: Off/On
    
    func switchMappingKeysModeOn() {
        keyConvertor.mappingKeysMode = true
        onButton.title = "Turn Off"
        onButton.state = 1
    }
    
    func switchMappingKeysModeOff() {
        keyConvertor.mappingKeysMode = false
        onButton.title = "Turn On"
        onButton.state = 0
    }
    
    //MARK: Key Event monitoring
    
    // Sets a block which will intercepts Quartz key events
    func grabKeys(monitorKeyBlock : MonitorKeyBlock) {
        println("MONITORING KEYS")
        keyConvertor.monitorKeyBlock = monitorKeyBlock
    }
    
    // Releases block above, so Quartz events can get through
    func releaseKeys() {
        println("MONITORING OFF")
        keyConvertor.monitorKeyBlock = nil
    }
    
    //MARK: Load/Save Mappings
    
    // Loads from standardUserDefaults and updates keyConvertor mappings array
    func loadKeyMappings() {
        currentKeyMappings = []
        if let mappings = NSUserDefaults.standardUserDefaults().objectForKey("mappings") as? [AnyObject] {
            for mapping in mappings {
                if let mappingDic = mapping as? [NSObject : AnyObject],
                    keyMapping = KeyMapping(dictionary: mappingDic) {
                        currentKeyMappings.append(keyMapping)
                }
            }
        }
        keyConvertor.mappings = currentKeyMappings //set mappings in converter
    }
    
    // Loads from given storage array (e.g. from file) and updates keyConvertor mappings array
    func loadKeyMappingsFromArray(mappings : NSArray) {
        currentKeyMappings = []
        
        for mapping in mappings {
            if let mappingDic = mapping as? [NSObject : AnyObject],
                keyMapping = KeyMapping(dictionary: mappingDic) {
                    currentKeyMappings.append(keyMapping)
            }
        }
        keyConvertor.mappings = currentKeyMappings //set mappings in converter
    }
    
    // Saves to standardUserDefaults and updates keyConvertor mappings array
    func saveKeyMappings() {
        var mappings : [AnyObject] = map(currentKeyMappings) { $0.toDictionary() }
        NSUserDefaults.standardUserDefaults().setObject(mappings, forKey: "mappings")
        keyConvertor.mappings = currentKeyMappings //set mappings in converter
    }
}