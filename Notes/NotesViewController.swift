//
//  ViewController.swift
//  Notes
//
//  Created by Salah  on 29/02/2020.
//  Copyright © 2020 Salah . All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray=[Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate=self
        // Do any additional setup after loading the view.
    }
    
    var selectedCategory : Parent? {
        didSet{
            loadItems()
        }
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
      
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          
          //        context.delete(itemArray[indexPath.row])
          //        itemArray.remove(at: indexPath.row)
          
          itemArray[indexPath.row].done = !itemArray[indexPath.row].done
          
          saveItems()
          
          tableView.deselectRow(at: indexPath, animated: true)
          
      }
    
    @IBAction func addItems(_ sender: UIButton) {
            var textField = UITextField()
                let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                    //what will happen once the user clicks the Add Item button on our UIAlert
                    let newItem = Item(context: self.context)
                    newItem.title = textField.text!
                    newItem.done = false
                    newItem.parentCategory=self.selectedCategory
                    self.itemArray.append(newItem)
                    self.saveItems()
                }
        
                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Create new item"
                    textField = alertTextField
        
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manupulation Methods
       
       func saveItems() {
           
           do {
               try context.save()
           } catch {
               print("Error saving context \(error)")
           }
           
           self.tableView.reloadData()
       }
       
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
           
           let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
           
           if let addtionalPredicate = predicate {
               request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
           } else {
               request.predicate = categoryPredicate
           }
           
           do {
               itemArray = try context.fetch(request)
           } catch {
               print("Error fetching data from context \(error)")
           }
           
           tableView.reloadData()
           
       }

}

//MARK: - Search bar methods
extension NotesViewController:UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request, predicate: predicate)
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }


}
