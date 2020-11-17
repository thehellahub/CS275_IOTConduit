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
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
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
    
    // Loading up initial allItems list
    init() {
//        for _ in 0..<5 {
//            createItem()
//        }
        let db = Firestore.firestore()
    }
    
}


