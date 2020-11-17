//
//  ItemStore.swift
//  Homepwner
//
//  Created by Nick Hella on 10/24/20.
//

import UIKit

class ItemStore{
    
    var allItems = [Item]()
    let itemArchiveURL: URL = {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        print(documentDirectory)
        return documentDirectory.appendingPathComponent("items.archive")
    }()
    
    func saveChanges() -> Bool {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: allItems, requiringSecureCoding: false)
            try data.write(to: itemArchiveURL)
            print("Saving items to: \(itemArchiveURL.path)")
            return true
        } catch {
            return false
        }
    }
    
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
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            if let archivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Item] {
                    allItems = archivedData
            }
        } catch {
            allItems = []
        }
    }
}
