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
    
    let groceryFiles = ["Baking", "Condiments", "Dairy", "Drinks", "Meat", "Misc", "Produce"]
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let name = groceryFiles.first!
        let baking = loadIngredientsFile(name)
        addGroceryAisle(name, items: baking)
    }
    
    override func willActivate() {
        super.willActivate()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var groceries = [(name: String, items: [Ingredient])]()
            for file in self.groceryFiles {
                if file != self.groceryFiles.first {
                    groceries.append((file, self.loadIngredientsFile(file)))
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                for grocery in groceries {
                    self.addGroceryAisle(grocery.name, items: grocery.items)
                }
            })
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        
        if let row = table.rowControllerAtIndex(rowIndex) as? GroceryRowController {
            row.strikethrough = !row.strikethrough
        }
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
                
                row.ingredient = items[i - rows - 1]
            }
        }
    }

    @IBAction func onRemovePurchased() {
        
        let itemsToRemove = NSMutableIndexSet()
        for i in 0...table.numberOfRows {
            
            if let row = table.rowControllerAtIndex(i) as? GroceryRowController where row.strikethrough {
                itemsToRemove.addIndex(i)
            }
        }
        table.removeRowsAtIndexes(itemsToRemove)
    }
}
