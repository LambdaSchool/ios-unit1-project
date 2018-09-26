//
//  SearchTableViewController.swift
//  Books
//
//  Created by Farhan on 9/24/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate, BorrowButtonDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let bookController = BookController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {return}
        bookController.searchForBook(with: searchText) { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.endEditing(true)
            }
            
        }
        
    }
    
    func borrowButtonWasPressed(_ sender: SearchTableViewCell) {
        
        guard let bookRep = sender.book else {return}
        
        guard let title = bookRep.volumeInfo.title, let id = bookRep.id, let publishedDate = bookRep.volumeInfo.publishedDate, let thumbnail = bookRep.volumeInfo.imageLinks?.thumbnail else {return}
    
        let alert = UIAlertController(title: "Do you want to add this book to your library?", message: "This will add the book to your library so that you can review it later.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            
            self.bookController.addBook(title: title, id: id, thumbnail: thumbnail, avgRating: bookRep.volumeInfo.averageRating, author: bookRep.volumeInfo.authors?.first, publishedDate: publishedDate)
            self.navigationController?.popViewController(animated: true)
            
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookController.searchedBooks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookSearchCell", for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}

        let book = bookController.searchedBooks[indexPath.row]
        
        cell.book = book
        cell.delegate = self

        return cell
    }
    

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
