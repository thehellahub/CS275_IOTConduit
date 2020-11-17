//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Nick Hella on 10/24/20.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    var imageStore: ImageStore!
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        print("Add new item clicked!")
        
        // Causes runtime error
//            // Make a new index path of the 0th section, last row
//            let lastRow = tableView.numberOfRows(inSection: 0)
//            let indexPath = IndexPath(row: lastRow, section: 0)
//
//            // Insert this new row into the table
//            tableView.insertRows(at: [indexPath], with: .automatic)
        
        // Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        // Figure out where that item is in the array
        if let index = itemStore.allItems.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Edit bar button item
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // for deleting a row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // if the table view is asking to commit a delete command (this will give us a chance to intercept the delete if we want to)
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) -> Void in
                
                // remove the item from the item store
                self.itemStore.removeItem(item)
                
                // remove the item's image from the image store
                self.imageStore.deleteImage(forKey: item.itemKey)
                
                // also remove that row from the table view with an animation
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            })
            
            ac.addAction(deleteAction)
            ac.addAction(cancelAction)
            
            // Present the alert controller
            present(ac, animated: true, completion: nil)
            
        }
    }
    
    // for moving a row
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    
    // Not needed with edit bar item
//    @IBAction func toggleEditingMode(_ sender: UIButton) {
//        print("Edit button clicked!")
//
//        // If you are currently in editing mode...
//        if isEditing {
//            // Change text of a button to inform user of state
//            sender.setTitle("Edit", for: .normal)
//
//            // Turn off editing mode
//            setEditing(false, animated: true)
//        } else {
//            // Change text of button to inform user of state
//            sender.setTitle("Done", for: .normal)
//
//            // Enter editing mode
//            setEditing(true, animated: false)
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create an instance of the UITableViewCell, with default appearance
        
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        // get a new or recycled cell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row of this cell
        // will appear in on the table view
        let item = itemStore.allItems[indexPath.row]
        
        //cell.textLabel?.text = item.name
        //cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        // Configure the cell with the Item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Get height of the status bar
//        let statusBarHeight = UIApplication.shared.statusBarFrame.height
//
//        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
//
//        tableView.contentInset = insets
//        tableView.scrollIndicatorInsets = insets
        
        //tableView.rowHeight = 65
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        
    }
    
    // ??? Adding sections like what you see on the far right of the contacts app to jump through sections of your contacts
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
//
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return itemStore.sectionIndexTitles
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If triggered segue is the "showItem" segue
        
        switch segue.identifier {
        case "showItem"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                
                // Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}


