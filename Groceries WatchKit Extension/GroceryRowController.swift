//
//  GroceryRowController.swift
//  Groceries
//
//  Created by User on 6/19/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import UIKit
import WatchKit

class GroceryRowController: NSObject {

    @IBOutlet var textLabel: WKInterfaceLabel!
    @IBOutlet var measurementLabel: WKInterfaceLabel!
    
    var ingredient: Ingredient? {
        didSet {
            //
        }
    }
    
    var strikethrough = false {
        didSet {
            //
        }
    }
    
    private var cellTextAttributes: [String: AnyObject] {
        return [NSFontAttributeName: UIFont.systemFontOfSize(16), NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    private var strikethroughCellTextAttributes: [String: AnyObject] {
        return [NSFontAttributeName: UIFont.systemFontOfSize(16), NSForegroundColorAttributeName: UIColor.lightGrayColor(), NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
    }
}
