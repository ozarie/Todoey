//
//  ViewController.swift
//  Todoey
//
//  Created by Oz Arie Tal Shachar on 11.2.2018.
//  Copyright © 2018 Oz Arie Tal Shachar. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let realm : Realm = try! Realm()
    
    var toDoItems : Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        let item : Item = toDoItems[indexPath.row]
        
        //because the itemArray is now an Item and not a String
        cell.textLabel?.text = item.title
        
        //Ternary Operator - short way
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row number: \(indexPath.row), Text is: \(toDoItems[indexPath.row])")
        
        //short way - will make the done property opposite
        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
        
        saveItems()
        
//        //how to delete items from the context (DB) and then from the item array, we will do it later.
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        tableView.reloadData()
        
        //change appearance of selected row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add new items
    
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
            
            let newItem : Item = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.toDoItems.append(newItem)
            
            self.saveItems()
        }
        
        alert.addAction(action)
        
        //show popup
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Model manipulation Methods
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving item array: \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadItems(){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}
    
//MARK: - SearchBar Delegate Methods

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0 {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

            //sortDescriptors - plural - it wants an array of sortDescriptors but we only have one so we have only one so we wrap it in an array
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

            loadItems(with: request, itemPredicate : predicate)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadItems()
        }
        
        
//        //you can do this here and than the array will be updated all the time so U see it automatically.
//        if searchBar.text?.count != 0 {
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//            //sortDescriptors - plural - it wants an array of sortDescriptors but we only have one so we have only one so we wrap it in an array
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//            loadItems(with: request)
//        }
    }
    
}
   




















