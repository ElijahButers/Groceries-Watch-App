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

public class Ingredient: NSObject {

  public let quantity: String
  public let name: String
  public let type: IngredientType
  public var purchased: Bool

  init(quantity: String, name: String, type: IngredientType) {
    self.quantity = quantity
    self.name = name
    self.type = type
    self.purchased = false
  }

  var formattedQuantity: String {
    let formatter = NSNumberFormatter();
    formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
    if let num = formatter.numberFromString(quantity) {
      if num.integerValue == 1 {
        return "\(num) item"
      } else {
        return "\(num) items"
      }
    }
    return quantity
  }

}

extension Ingredient {

  static func fromJSON(json: JSON) -> [Ingredient] {
    return json.arrayValue.map({ ingredientJSON in
      let quantity = ingredientJSON["quantity"].stringValue
      let name = ingredientJSON["name"].stringValue
      let type = IngredientType(rawValue: ingredientJSON["type"].stringValue)
      return Ingredient(quantity: quantity, name: name, type: type!)
    })
  }

}

public func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
  return lhs.quantity == rhs.quantity &&
    lhs.name == rhs.name &&
    lhs.type == rhs.type
}
