//
//  SwipeCellViewController.swift
//  Notes
//
//  Created by Salah  on 03/03/2020.
//  Copyright © 2020 Salah . All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeCellViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight=80.0
     
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
           
        cell.delegate = self
           
           return cell
    }
    
   // MARK:-Swipe Cell Methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateCell(at: indexPath)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "trash")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }

    func updateCell(at indexPath:IndexPath){
        
    }

}
