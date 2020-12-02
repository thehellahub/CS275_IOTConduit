//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Nick Hella on 10/25/20.
//

import UIKit
import Firebase
import Firestore

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    var item: Item! {
        didSet {
            navigationItem.title = "\(item.Make) \(item.Model)"
        }
    }
    var newItem = false
    
    
    @IBOutlet var idField: UITextField! // ID field
    @IBOutlet var dateLabel: UILabel! // Unused
    @IBOutlet var nameField: UITextField! // "Make" Text field
    @IBOutlet var serialNumberField: UITextField! // "Model" Text Field
    @IBOutlet var valueField: UITextField! // "Year" Text Field
    @IBOutlet var weightField: UITextField! // "Weight" Text Field
    @IBOutlet var horsepowerField: UITextField! // "Horsepower" Text Field
    @IBOutlet var priceField: UITextField! // "Year" Text Field
    
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        idField.text = item.ID
        nameField.text = item.Make
        serialNumberField.text = item.Model
        valueField.text = "\(item.Year)"
        horsepowerField.text = "\(item.Horsepower)"
        weightField.text = "\(item.Weight)"
        priceField.text = numberFormatter.string(from: NSNumber(value: item.Price))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear the first responder (keyboard)
        view.endEditing(true)
        
        // "Save" changes to item
        item.Make = nameField.text ?? ""
        item.Model = serialNumberField.text ?? ""
        
        if let valueText = valueField.text, let value = numberFormatter.number(from: valueText) {
            item.Year = value.intValue
        } else {
            item.Year = 0
        }
        
        if let weightText = weightField.text, let value = numberFormatter.number(from: weightText) {
            item.Weight = value.intValue
        } else {
            item.Weight = 0
        }
        
        if let horsepowerText = horsepowerField.text, let value = numberFormatter.number(from: horsepowerText) {
            item.Horsepower = value.intValue
        } else {
            item.Horsepower = 0
        }
        
        if let priceText = priceField.text, let value = numberFormatter.number(from: priceText) {
            item.Price = value.intValue
        } else {
            item.Price = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func innerDeleteButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        print("inner delete button pressed")
        
        var id = idField.text ?? "" // getting the text in the ID field
        
        // If the ID field has text in it
        if id.count > 0 {
            
            // Establishing connection to the DB
            let db = Firestore.firestore() // Load the Firestore db
            
            // Delete item from the db where id = item.ID
            db.collection("car_data").document(id).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            
            // Go back to item view controller
            // see func "unwind" in ItemsViewController.swift
            performSegue(withIdentifier: "unwind", sender: sender) // unwind the segue
        
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        // "Save" changes to item
        item.ID = idField.text ?? ""
        item.Make = nameField.text ?? ""
        item.Model = serialNumberField.text ?? ""
        
        if item.Make.count > 0 && item.Model.count > 0 {
        
            if let valueText = valueField.text, let value = numberFormatter.number(from: valueText) {
                item.Year = value.intValue
            } else {
                item.Year = 0
            }
            
            if let weightText = weightField.text, let value = numberFormatter.number(from: weightText) {
                item.Weight = value.intValue
            } else {
                item.Weight = 0
            }
            
            if let horsepowerText = horsepowerField.text, let value = numberFormatter.number(from: horsepowerText) {
                item.Horsepower = value.intValue
            } else {
                item.Horsepower = 0
            }
            
            if let priceText = priceField.text, let value = numberFormatter.number(from: priceText) {
                item.Price = value.intValue
            } else {
                item.Price = 0
            }
            
    //        print("\n\n New Item!")
    //        print("ID => \(item.ID)")
    //        print("Make => \(item.Make)")
    //        print("Model => \(item.Model)")
    //        print("Year => \(item.Year)")
    //        print("Weight => \(item.Weight)")
    //        print("Horsepower => \(item.Horsepower)")
    //        print("Price => \(item.Price)")
                    
            // Add new item to the DB, or update it if it already exists
            let db = Firestore.firestore() // Load the Firestore db
            
            db.collection("car_data").document(item.ID).setData([
                "Make": item.Make,
                "Model": item.Model,
                "Year": item.Year,
                "Weight": item.Weight,
                "Horsepower": item.Horsepower,
                "Price": item.Price
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
            // Go back to item view controller
            // see func "unwind" in ItemsViewController.swift
            performSegue(withIdentifier: "unwind", sender: sender) // unwind the segue
            
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}
