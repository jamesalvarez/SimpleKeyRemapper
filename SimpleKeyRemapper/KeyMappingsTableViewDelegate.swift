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


class KeyMappingsTableViewDelegate : NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    //MARK: Outlets
    
    @IBOutlet var tableView : NSTableView!
    @IBOutlet var controller : KeyMappingsController!
    @IBOutlet var inputColumn : NSTableColumn!
    @IBOutlet var outputColumn : NSTableColumn!
    
    //MARK: Vars
    
    var mappings : [KeyMapping] = []
    var reloading : Bool = false
    
    
    //MARK: Reload
    
    func reload(newMappings : [KeyMapping]) {
        mappings = newMappings
        reloading = true
        tableView.reloadData()
        reloading = false
    }
    
    func getSelected() -> Int? {
        if tableView.selectedRow > -1 && tableView.selectedRow < mappings.count {
            return tableView.selectedRow
        } else {
            return nil
        }
    }
    
    //MARK: Datasource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        println("refreshing number count with \(mappings.count) mappings")
        return mappings.count
    }
    
    //MARK: Delegate
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn == inputColumn {
            let view = tableView.makeViewWithIdentifier(inputColumn.identifier, owner: nil) as? NSTableCellView
            view?.textField?.stringValue = mappings[row].inputKey.stringValue
            return view
        } else if tableColumn == outputColumn {
            let view = tableView.makeViewWithIdentifier(outputColumn.identifier, owner: nil) as? NSTableCellView
            view?.textField?.stringValue = mappings[row].outputKey.stringValue
            return view
        }
        return nil
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if !reloading {
            println("Selection Did Changed")
            controller.changeCurrentSelection(getSelected())
        }
    }
    
}