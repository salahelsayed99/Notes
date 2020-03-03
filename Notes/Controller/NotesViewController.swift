//
//  ViewController.swift
//  Notes
//
//  Created by Salah  on 29/02/2020.
//  Copyright © 2020 Salah . All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class NotesViewController: SwipeCellViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var realm = try! Realm()
    
    var itemArray:Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate=self
        // Do any additional setup after loading the view.
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colourHex = selectedCategory?.colour {
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
            }
            if let navBarColour = UIColor(hexString: colourHex) {
                //Original setting: navBar.barTintColor = UIColor(hexString: colourHex)
                //Revised for iOS13 w/ Prefer Large Titles setting:
                navBar.barTintColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                navBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:ContrastColorOf(navBarColour, returnFlat: true)]
            }
        }
    }
    
    var selectedCategory : Parent? {
        didSet{
            loadItems()
        }
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if  let item = itemArray?[indexPath.row]{
            cell.textLabel?.text = item.title
            if let colour=UIColor(hexString:selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(itemArray!.count)){
                cell.backgroundColor=colour
                cell.textLabel?.textColor=ContrastColorOf(colour, returnFlat: true)
            }
            
            
            //Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none}
        else{
            cell.textLabel?.text = "No items added yet"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let itemArray=itemArray?[indexPath.row]{
            do{
                try realm.write {
                    itemArray.done = !itemArray.done
                }
                tableView.reloadData()
            }
            catch{
                print("error")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func updateCell(at indexPath: IndexPath) {
        do{
            try realm.write {
                realm.delete(itemArray![indexPath.row])
            }
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func addItems(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            if let currentCategory=self.selectedCategory?.items{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        
                        currentCategory.append(newItem)
                    }
                }
                catch{
                    print("Error")
                }
                
                self.tableView.reloadData()
                
            }
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
        do{
            try realm.write {
                
            }
        }
        catch{
            print(error)
        }
    }
    
    func loadItems() {
        
        itemArray=selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    
}

//MARK: - Search bar methods
extension NotesViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        itemArray = itemArray?.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!))
        
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}
