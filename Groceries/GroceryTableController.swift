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

import UIKit

class GroceryTableController: UITableViewController {

  let loader = GroceryLoader()
  var sections: [GroceryLoader.GrocerySection]?
  var selectedItems = [NSIndexPath]()

  override func viewDidLoad() {
    super.viewDidLoad()

    loader.load { groceries in
      self.sections = groceries
      self.tableView.reloadData()
    }
  }

  @IBAction func onAction(sender: AnyObject) {
    let controller = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)

    let remove = UIAlertAction(title: "Remove Purchased", style: .Destructive) { _ in
      self.removePurchased()
    }

    let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { _ in }

    controller.addAction(remove)
    controller.addAction(cancel)
    presentViewController(controller, animated: true, completion: nil)
  }

  func removePurchased() {
    let sortedPaths = selectedItems.sort { p1, p2 -> Bool in
      if p1.section == p2.section {
        return p1.row > p2.row
      } else {
        return p1.section > p2.section
      }
    }

    let removedSections = NSMutableIndexSet()
    for path in sortedPaths {
      sections?[path.section].items.removeAtIndex(path.row)

      if sections?[path.section].items.count == 0 {
        sections?.removeAtIndex(path.section)
        removedSections.addIndex(path.section)
      }
    }

    tableView.beginUpdates()
    tableView.deleteRowsAtIndexPaths(selectedItems, withRowAnimation: .Automatic)
    tableView.deleteSections(removedSections, withRowAnimation: .Automatic)
    selectedItems.removeAll()
    tableView.endUpdates()
  }

  //MARK: UITableViewDataSource

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return sections?.count ?? 0
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections?[section].items.count ?? 0
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections?[section].name
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("GroceryCell", forIndexPath: indexPath) as! GroceryCell
    if let item = sections?[indexPath.section].items[indexPath.row] {
      let strike = selectedItems.contains(indexPath)
      cell.setText(item.name.capitalizedString, strikethrough: strike)
      cell.detailTextLabel?.text = item.formattedQuantity
    }
    return cell
  }

  //MARK: UITableViewDelegate

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    if let item = sections?[indexPath.section].items[indexPath.row] {
      let cell = tableView.cellForRowAtIndexPath(indexPath) as! GroceryCell
      let index = selectedItems.indexOf(indexPath)
      cell.setText(item.name.capitalizedString, strikethrough: (index == nil))
      if let index = index {
        selectedItems.removeAtIndex(index)
      } else {
        selectedItems.append(indexPath)
      }
    }
  }

}
