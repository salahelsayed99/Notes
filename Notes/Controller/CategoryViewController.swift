//
//  CategoryViewController.swift
//  Notes
//
//  Created by Salah  on 29/02/2020.
//  Copyright © 2020 Salah . All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeCellViewController {
    var categories:Results<Parent>?
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
            guard let navbar=navigationController?.navigationBar else {fatalError("error")}
            navbar.barTintColor=UIColor(hexString: "1D9BF6")
            navbar.tintColor = .white
            navbar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:FlatWhite()]
            tableView.reloadData()
        }

    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category=categories?[indexPath.row]{
        cell.textLabel?.text = category.name
        cell.backgroundColor=UIColor(hexString: category.colour)
            cell.textLabel?.textColor=ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        }
        return cell
        
    }
    
    
    
    override func updateCell(at indexPath: IndexPath) {
        do{
           try realm.write {
            realm.delete(categories![indexPath.row])
            }
        }
        catch{
            print(error)
        }
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NotesViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    @IBAction func addCategory(_ sender: UIButton) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
                    let newCategory = Parent()
                    newCategory.name = textField.text!
            newCategory.colour = (UIColor.randomFlat().hexValue())
                    self.saveCategory(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory(category:Parent) {
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print(error)
        }
        tableView.reloadData()
        
    }
    
    
    func loadCategories() {
        
        categories=realm.objects(Parent.self)
        
        tableView.reloadData()
        
    }
    
}


