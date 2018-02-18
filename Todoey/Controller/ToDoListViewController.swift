//
//  ViewController.swift
//  Todoey
//
//  Created by Oz Arie Tal Shachar on 11.2.2018.
//  Copyright © 2018 Oz Arie Tal Shachar. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    //create the context for AppDelegete singleton
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var itemArray : [Item] = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadItems()
        
    }
    
    
    //MARK: - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        let item : Item = itemArray[indexPath.row]
        
        //because the itemArray is now an Item and not a String
        cell.textLabel?.text = item.title
        
        //Ternary Operator - short way
        cell.accessoryType = item.done ? .checkmark : .none
        
        
//        //long way
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row number: \(indexPath.row), Text is: \(itemArray[indexPath.row])")
        
        //short way - will make the done property opposite
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
//        //how to delete items from the context (DB) and then from the item array, we will do it later.
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
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
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            //reload the table view with our new items
            self.tableView.reloadData()
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
    }
    
    //החלק שאחרי סימן השוויון אומר שאם לא העברתי פרמטר אז הוא טוען את כל הנתונים ומביא אותם. כלומר, אני נותן לו ערך דיפולטיבי.
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()){
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        tableView.reloadData()
    }
}
    
//MARK: - SearchBar Delegate Methods

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0 {
            let request : NSFetchRequest<Item> = Item.fetchRequest()

            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

            //sortDescriptors - plural - it wants an array of sortDescriptors but we only have one so we have only one so we wrap it in an array
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

            loadItems(with: request)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadItems()
        }
        
        
//        //you can do this here and than the array will be updated all the time
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
   




















