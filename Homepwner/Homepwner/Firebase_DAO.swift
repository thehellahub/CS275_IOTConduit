//
//  Firebase_DAO.swift
//  Homepwner
//
//  Created by Nick Hella on 11/8/20.
//  Copyright © 2020 IOTConduit. All rights reserved.
//
import UIKit
import Firebase
import Firestore


class FireBaseAPI_Handler {
    
    var Items_in_DB = [Item]()
    
    func returnAllData(completion:@escaping(([Item]) -> ())) -> [Item]{
        
        print("\nFireBaseAPI_Handler.returnAllData function called!\n")
        
        self.Items_in_DB = [] // clearing the Items in our db
        
        // Debug count variable
        var count = 1

        // Query the sewage data collection for a list of the unique locations in our db
        let dispatchGroup = DispatchGroup()

        // Load the Firestore db
        let db = Firestore.firestore()
        dispatchGroup.enter()
        db.collection("car_data").getDocuments() { (querySnapshot, err) in

            if let err = err {
                print("Error getting documents: \(err)")
                dispatchGroup.leave()
            } else {

                // Iterate through the documents
                for document in querySnapshot!.documents {
                    
                    // Get the whole document as dictionary
                    let testVar = document.data()
                    let id = document.documentID as! String
                    let make = testVar["Make"]! as! String
                    let model = testVar["Model"]! as! String
                    let year = testVar["Year"]! as! Int
                    let weight = testVar["Weight"]! as! Int
                    let horsepower = testVar["Horsepower"]! as! Int
                    let price = testVar["Price"]! as! Int
                    
//                    print("\(document.documentID) => \(document.data())")
//                    print("Make => \(make)")
//                    print("Model => \(model)")
//                    print("Year => \(year)")
//                    print("Weight => \(weight)")
//                    print("Horsepower => \(horsepower)")
//                    print("Price => \(price)")
                    
                    let newItem = Item(ID: id, Make: make, Model: model, Year: year, Weight: weight, Horsepower: horsepower, Price: price)
                    
                    self.Items_in_DB.append(newItem)

                    print("\t\tAdding item #\(count)") // debug print statement
                    count = count + 1
                    
                } // end for
                dispatchGroup.leave()
            } // end else
        } // end db query
        dispatchGroup.notify(queue:.main) {
            completion(self.Items_in_DB)
        }
        return self.Items_in_DB
    } // end func
    
    func deleteItem(id: String) {
        let db = Firestore.firestore()
        db.collection("car_data").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func sortStore() {
        self.Items_in_DB = self.Items_in_DB.sorted(by: { $0.Make < $1.Make }) // sorting the store
    }
} // end class
