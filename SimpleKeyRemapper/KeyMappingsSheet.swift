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

class KeyMappingsSheet : NSObject {
    
    //MARK: Outlets
    
    @IBOutlet var mainWindow : NSWindow!
    @IBOutlet var sheetWindow : NSWindow!
    @IBOutlet var mappingsController : KeyMappingsController!
    @IBOutlet var keyConverterController : KeyConverterController!
    
    var topLevelObjects : NSArray?
    
    //MARK: Actions
    
    @IBAction func displaySheet(AnyObject) {
        
        if sheetWindow == nil {
            NSBundle.mainBundle().loadNibNamed("KeyMappingsWindow", owner: self, topLevelObjects: &topLevelObjects)
        }
        
        keyConverterController.switchMappingKeysModeOff()
        
        mainWindow.beginSheet(sheetWindow, completionHandler: {
            (response : NSModalResponse) -> () in
            NSApp.stopModalWithCode(response)
        })
        NSApp.runModalForWindow(sheetWindow)
    }
    
    @IBAction func closeSheet(AnyObject) {
        keyConverterController.switchMappingKeysModeOn()
        keyConverterController.releaseKeys()
        mainWindow.endSheet(sheetWindow)
    }
    
    @IBAction func saveToFile(AnyObject) {
        //open the file dialog
        keyConverterController.switchMappingKeysModeOff()
        
        var savePanel = NSSavePanel()
        savePanel.title = "Saving mappings file"
        savePanel.showsResizeIndicator = true
        savePanel.showsHiddenFiles = false
        savePanel.canCreateDirectories = true
        savePanel.allowedFileTypes = ["plist"]
        savePanel.beginSheetModalForWindow(sheetWindow, completionHandler: {
            (int_code : Int) -> () in
            if int_code == NSFileHandlingPanelOKButton {
                //relative to files location
                if let url = savePanel.URL, path = url.path {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if let dict : NSArray = NSUserDefaults.standardUserDefaults().objectForKey("mappings") as? NSArray {
                            dict.writeToFile(path, atomically: true)
                        }
                        
                    })
                }
            }
        })
    }
    
    @IBAction func loadFromFile(AnyObject) {
        //open the file dialog
        
        keyConverterController.switchMappingKeysModeOff()
        
        var openPanel = NSOpenPanel()
        openPanel.title = "Choose any file"
        openPanel.showsResizeIndicator = true
        openPanel.showsHiddenFiles = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.allowedFileTypes = ["plist"]
        openPanel.beginSheetModalForWindow(sheetWindow, completionHandler: {
            (int_code : Int) -> () in
            if int_code == NSFileHandlingPanelOKButton {
                //relative to files location
                if let url = openPanel.URL,
                       path = url.path,
                       array = NSArray(contentsOfFile: path) {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.keyConverterController.loadKeyMappingsFromArray(array)
                        self.mappingsController.reload()
                    })
                }
                
            }
        })
    }
}