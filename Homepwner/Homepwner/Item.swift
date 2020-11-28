//
//  Item.swift
//  Homepwner
//
//  Created by Nick Hella on 10/24/20.
//

import UIKit

class Item: NSObject {
    var ID: String
    var Make: String
    var Model: String
    var Year: Int
    var Weight: Int
    var Horsepower: Int
    var Price: Int
    
    // Designated initilializer
    init(ID: String, Make: String, Model: String, Year: Int, Weight: Int, Horsepower: Int, Price: Int) {
        self.ID = ID
        self.Make = Make
        self.Model = Model
        self.Year = Year
        self.Weight = Weight
        self.Horsepower = Horsepower
        self.Price = Price
        
        super.init()
    }
    
    // Convenience initializer
    convenience init(random: Bool = false) {
        self.init(ID: "", Make: "", Model: "", Year: 0, Weight: 0, Horsepower: 0, Price: 0)
    } // end convenience init
    
    func getID() -> String {
        return self.ID
    }
    func getMake() -> String {
        return self.Make
    }
    func getModel() -> String {
        return self.Model
    }
    func getYear() -> Int {
        return self.Year
    }
    func getWeight() -> Int {
        return self.Weight
    }
    func getHorsepower() -> Int {
        return self.Horsepower
    }
    func getPrice() -> Int {
        return self.Price
    }

}
