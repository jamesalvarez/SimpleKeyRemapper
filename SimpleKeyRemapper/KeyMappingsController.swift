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

class KeyMappingsController : NSObject {
    
    //MARK: Outlets
    
    @IBOutlet var segmentedControl : NSSegmentedControl!
    @IBOutlet var inputTextField : KeyDetectorTextField!
    @IBOutlet var outputTextField : KeyDetectorTextField!
    @IBOutlet var tableViewController : KeyMappingsTableViewDelegate!
    @IBOutlet var sheet : KeyMappingsSheet!
    
    
    //MARK: Vars
    
    var selectedMappingIndex : Int?
    var keyConverterController : KeyConverterController!
    
    //MARK: Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        keyConverterController = sheet.keyConverterController
        reload()
    }
    
    
    //MARK Actions
    
    @IBAction func actionsSegmentedControlClicked(sender : AnyObject) {
        switch(segmentedControl.selectedSegment) {
        case 0:
            //add
            let newMapping = KeyMapping()
            keyConverterController.currentKeyMappings.append(newMapping)
            changeCurrentSelection(keyConverterController.currentKeyMappings.count - 1)
            registerUpdateToMappings()

        case 1:
            //delete selected
            if let selected = tableViewController.getSelected() {
                keyConverterController.currentKeyMappings.removeAtIndex(selected)
            }
            changeCurrentSelection(nil)
            registerUpdateToMappings()

        default:
            break
        }
    }
    
    //MARK: Refresh / reload methods
    
    func reload() {
        tableViewController.reload(keyConverterController.currentKeyMappings)
        changeCurrentSelection(nil)
    }
    
    // Called when updating key mappings array
    func registerUpdateToMappings() {
        keyConverterController.saveKeyMappings()
        tableViewController.reload(keyConverterController.currentKeyMappings)
    }

    // Called on reload, and when user changes selection
    func changeCurrentSelection(selected : Int?) {
        
        selectedMappingIndex = selected
        
        if let selectedMappingIndex = selectedMappingIndex {
            let mapping = keyConverterController.currentKeyMappings[selectedMappingIndex]
            inputTextField.enabled = true
            outputTextField.enabled = true
            
            inputTextField.keyDetected = mapping.inputKey
            outputTextField.keyDetected = mapping.outputKey
        } else {
            inputTextField.enabled = false
            outputTextField.enabled = false
            segmentedControl.setEnabled(false, forSegment: 1)
        }
    }
    
    //Called by KeyDetectorTextField when a new key is set
    func inputKeyChanged() {
        if let selectedMappingIndex = selectedMappingIndex,
            inputKey = inputTextField.keyDetected,
            outputKey = outputTextField.keyDetected {
                let mapping = keyConverterController.currentKeyMappings[selectedMappingIndex]
                mapping.inputKey = inputKey
                mapping.outputKey = outputKey
                registerUpdateToMappings()
        }
    }

}