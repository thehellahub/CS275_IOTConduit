//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Nick Hella on 10/24/20.
//

import UIKit
import Firebase
import Firestore


class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    var dispatchGroup = DispatchGroup()
    var Firebase_API_Handler = FireBaseAPI_Handler()
    
    var store_item_count = 0
    var store_ping_attempts = 0
        
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        print("Add new item button clicked!")
    }
    
    func addNewItem_from_DB(ID: String, Make: String, Model: String, Year: Int, Weight: Int, Horsepower: Int, Price: Int) {
        
        //Create a new item and add it to the store
        let newItem = itemStore.createItem(ID: ID, Make: Make, Model: Model, Year: Year, Weight: Weight, Horsepower: Horsepower, Price: Price)

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
            
            let title = "Delete \(item.Make)"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) -> Void in
                
                // remove the item from the store
                self.itemStore.removeItem(item)
                // also remove that row from the table view with an animation
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                // Remove the item from the db
                self.Firebase_API_Handler.deleteItem(id: item.ID)
                self.viewDidLoad()
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
    
    //Not needed with edit bar item
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        print("Edit button clicked!")

        // If you are currently in editing mode...
        if isEditing {
            // Change text of a button to inform user of state
            sender.setTitle("Edit", for: .normal)

            // Turn off editing mode
            setEditing(false, animated: true)
        } else {
            // Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)

            // Enter editing mode
            setEditing(true, animated: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create an instance of the UITableViewCell, with default appearance
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row of this cell
        // will appear in on the table view
        let item = itemStore.allItems[indexPath.row]
        
        // Configure the cell with the Item
        cell.nameLabel.text = item.Make
        cell.serialNumberLabel.text = item.Model
        cell.valueLabel.text = "$\(item.Price)"
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView.rowHeight = 65
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        
        self.itemStore.clearStore() // get rid of everything in the item store
        self.itemStore.sortStore() // get rid of everything in the item store
        self.tableView.reloadData() // reload the table
        
        self.spinner.hidesWhenStopped = true
        self.spinner.startAnimating()
        
        // Try to pull it from the db
        self.dispatchGroup.enter() // Starting thread
        Firebase_API_Handler.returnAllData { result in
            let dbItems = result
            var count = 0
            while count < dbItems.count {
                self.addNewItem_from_DB(
                    ID: dbItems[count].getID(),
                    Make: dbItems[count].getMake(),
                    Model: dbItems[count].getModel(),
                    Year: dbItems[count].getYear(),
                    Weight: dbItems[count].getWeight(),
                    Horsepower: dbItems[count].getHorsepower(),
                    Price: dbItems[count].getPrice()
                )
                self.tableView.reloadData()
                count = count + 1
            }
            print("Count of all items in our item store ==> \(self.itemStore.allItems.count)")
            self.dispatchGroup.leave() // Leaving thread when result comes back
            self.itemStore.sortStore()
            
            if (self.itemStore.allItems.count != self.store_item_count) {
                self.store_item_count = self.itemStore.allItems.count
                self.store_ping_attempts = 0
                self.spinner.stopAnimating()
                return
            }
            else if (self.store_ping_attempts < 5) {
                print("Waiting for DB updates.. Attemp # \(self.store_ping_attempts)")
                self.store_ping_attempts = self.store_ping_attempts + 1
                self.viewDidLoad()
                
            } else {
                print("Update received!")
                self.store_ping_attempts = 0
                self.spinner.stopAnimating()
                return
            }
        }
        
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem"?:
            // Takes you to the page with lower-level details
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.newItem = false
            } 
        default:
            //preconditionFailure("Unexpected segue identifier")
            let item = itemStore.itemShell(ID: randomString(length: 20), Make: "", Model: "", Year: 0, Weight: 0, Horsepower: 0, Price: 0)
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.item = item
            detailViewController.newItem = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // Manual way to programatically unwind the segue
    @IBAction func unwind(_ segue: UIStoryboardSegue){
        // When returning from the details segue, reload the db contents to the main page
        viewDidLoad() // re-populate our table
    }
    
}


