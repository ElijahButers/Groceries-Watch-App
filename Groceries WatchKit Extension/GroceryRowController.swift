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
            configureController()
        }
    }
    
    var strikethrough = false {
        didSet {
            configureController()
        }
    }
    
    private var cellTextAttributes: [String: AnyObject] {
        return [NSFontAttributeName: UIFont.systemFontOfSize(16), NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    private var strikethroughCellTextAttributes: [String: AnyObject] {
        return [NSFontAttributeName: UIFont.systemFontOfSize(16), NSForegroundColorAttributeName: UIColor.lightGrayColor(), NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
    }
    
    func configureController() {
        
        guard let ingredient = ingredient else {
            return
        }
        
        let attributes: [String: AnyObject]
        if strikethrough {
            attributes = strikethroughCellTextAttributes
        } else {
            attributes = cellTextAttributes
        }
        
        let attributedText = NSAttributedString(string: ingredient.name.capitalizedString, attributes: attributes)
        textLabel.setAttributedText(attributedText)
        measurementLabel.setText(ingredient.formattedQuantity)
    }
}
