//
//  ViewController.swift
//  Todoey
//
//  Created by Oz Arie Tal Shachar on 11.2.2018.
//  Copyright © 2018 Oz Arie Tal Shachar. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray : [String] = ["Shoshana", "Damary", "Ofra Haza"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Tableview Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row number: \(indexPath.row), Text is: \(itemArray[indexPath.row])")
        
        //add checkbox to selected row
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        
        
        //change appearance of selected row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //var to save text from popup
        var textField = UITextField()
        
        //create popup alert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //add text field to popup alert
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        //create action to alert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks add
            self.itemArray.append(textField.text!)
            print(self.itemArray)
            
            //reload the table view with our new items
            self.tableView.reloadData()
        }
        
        
        
        alert.addAction(action)
        
        //show popup
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
}

