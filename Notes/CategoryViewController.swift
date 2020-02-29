//
//  CategoryViewController.swift
//  Notes
//
//  Created by Salah  on 29/02/2020.
//  Copyright © 2020 Salah . All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categories=[Parent]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "goToItem", sender: self)
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destinationVC = segue.destination as! NotesViewController
         
         if let indexPath = tableView.indexPathForSelectedRow {
             destinationVC.selectedCategory = categories[indexPath.row]
         }
     }
    
    @IBAction func addCategory(_ sender: UIButton) {
        var textField = UITextField()
               
               let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
               
               let action = UIAlertAction(title: "Add", style: .default) { (action) in
                   let newCategory = Parent(context: self.context)
                   newCategory.name = textField.text!
                   self.categories.append(newCategory)
                   self.saveCategories()
               }
               
               alert.addAction(action)
               alert.addTextField { (field) in
                   textField = field
                   textField.placeholder = "Add a new category"
               }
               
               present(alert, animated: true, completion: nil)
    }
    

    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        let request : NSFetchRequest<Parent> = Parent.fetchRequest()
        
        do{
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
        
    }

}
