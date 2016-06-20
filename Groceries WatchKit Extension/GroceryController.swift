/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation
import WatchKit

class GroceryController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let name = "Baking"
        let baking = loadIngredientsFile(name)
        addGroceryAisle(name, items: baking)
    }
    
    func loadIngredientsFile(file: String) -> [Ingredient] {
        
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let json = JSON(data: data)
        return Ingredient.fromJSON(json)
    }
  
    func addGroceryAisle(name: String, items: [Ingredient]) {
        
        let rows = table.numberOfRows
        
        let headerIndex = NSIndexSet(index: rows)
        table.insertRowsAtIndexes(headerIndex, withRowType: "GroceryTypeRow")
        let itemRows = NSIndexSet(indexesInRange: NSRange(location: rows + 1, length: items.count))
        table.insertRowsAtIndexes(itemRows, withRowType: "GroceryRow")
        
        for i in rows..<table.numberOfRows {
            let row = table.rowControllerAtIndex(i)
            
            if let row = row as? GroceryTypeRowController {
                row.textLabel.setText(name)
                row.image.setImageNamed(name.lowercaseString)
            } else if let row = row as? GroceryRowController {
                
                let item = items[i - rows - 1]
                row.textLabel.setText(item.name.capitalizedString)
                row.measurementLabel.setText(item.formattedQuantity)
            }
        }
    }

}
