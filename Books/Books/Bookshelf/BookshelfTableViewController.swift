//
//  BookshelfTableViewController.swift
//  Books
//
//  Created by Sergey Osipyan on 1/5/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit

class BookshelfTableViewController: UITableViewController {

    var bookshelf: BookshelfJson? {
        didSet {
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // tableView.reloadData()
     
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 11
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookshelf", for: indexPath) as! BookshelfTableViewCell

        // Configure the cell...
        guard let bookshelf = ModelBookshelf.shared.bookshelf else {return cell}
        cell.bookshelfTitle.text = bookshelf.items[indexPath.row].title
        cell.bookshelfId.text = "ID: \(bookshelf.items[indexPath.row].id)"
        if let volumeCount = bookshelf.items[indexPath.row].volumeCount {
            cell.bookshelfVolumeCount.text = "Books in shelf: \(String(describing: volumeCount))" }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search" {
            guard let indexPath = tableView.indexPathForSelectedRow
                else {return}
            let destination = segue.destination as! BookshelfDetailViewController
            let bookshelf = ModelBookshelf.shared.bookshelf?.items[indexPath.row]
            destination.bookshelf = bookshelf
        }
    }
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            ModelBookshelf.shared.deleteBookshelf(at: indexPath)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//    }
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
