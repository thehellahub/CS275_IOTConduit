//
//  ItemStore.swift
//  Homepwner
//
//  Created by Nick Hella on 10/24/20.
//

import UIKit
import Firestore
import Firebase

class ItemStore{
    
    var allItems = [Item]()
    
    // @discardableResult means the caller can ignore the return object
    @discardableResult func createItem(ID: String, Make: String, Model: String, Year: Int, Weight: Int, Horsepower: Int, Price: Int) -> Item {
        
        let newItem = Item(ID: ID, Make: Make, Model: Model, Year: Year, Weight: Weight, Horsepower: Horsepower, Price: Price)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    // @discardableResult means the caller can ignore the return object
    @discardableResult func addNewItem(newItem: Item) -> Item {
        allItems.append(newItem)
        return newItem
    }
    
    // @discardableResult means the caller can ignore the return object
    @discardableResult func itemShell(ID: String, Make: String, Model: String, Year: Int, Weight: Int, Horsepower: Int, Price: Int) -> Item {
        
        let newItem = Item(ID: ID, Make: Make, Model: Model, Year: Year, Weight: Weight, Horsepower: Horsepower, Price: Price)
                
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        // get reference to the object being moved so that we can reinsert it
        let movedItem = allItems[fromIndex]
        
        // remove the item from array
        allItems.remove(at: fromIndex)
        
        // insert it in the array at the new position
        allItems.insert(movedItem, at: toIndex)
    }
    
    func clearStore(){
        print("Clearing the store")
        var count = 0
        while count < self.allItems.count {
            self.removeItem(allItems[count])
            count = count + 1
        }
        self.allItems = []
        print("\tNo more items in the store!")
        print("\t\tStore # items => \(self.allItems.count)")
    }
    
    func sortStore() {
        self.allItems = self.allItems.sorted(by: { $0.Make < $1.Make })
    }
    
}
