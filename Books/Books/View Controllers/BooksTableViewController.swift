//
//  BooksTableViewController.swift
//  Books
//
//  Created by Linh Bouniol on 8/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

class BooksTableViewController: UITableViewController, BookTableViewCellDelegate {
    
    var bookController: BookController?
    var bookshelf: Bookshelf? {
        didSet {
            navigationItem.title = bookshelf?.name
        }
    }
    
    @IBAction func renameBookshelf(_ sender: Any) {
        
        let alert = UIAlertController(title: "Rename Bookshelf", message: nil, preferredStyle: .alert)
        alert.addTextField { (titleTextField) in
            titleTextField.placeholder = "Bookshelf Name:"
            
            // Current name before you change it
            titleTextField.text = self.bookshelf?.name
        }
        
        alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { (action) in
            guard let newName = alert.textFields![0].text, newName.count > 0, let bookshelf = self.bookshelf else { return }
            
            self.bookController?.rename(bookshelf: bookshelf, with: newName)
            
            // current name after you change it
            self.navigationItem.title = bookshelf.name
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    func toggleRead(for cell: BookTableViewCell) {
        guard let book = cell.book else { return }
        bookController?.toggleHasRead(for: book)
    }
    
    
    
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookshelf?.books?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell

        cell.book = bookshelf?.books?[indexPath.row] as? Book
        cell.delegate = self
    
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let book = bookshelf?.books?[indexPath.row] as? Book else { return }
            bookController?.delete(book: book)
            
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchBooksTableViewController {
            searchVC.bookController = bookController
            searchVC.bookshelf = bookshelf
        }
        
        if let bookDetailVC = segue.destination as? BookDetailViewController {
            bookDetailVC.bookController = bookController
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            bookDetailVC.book = bookshelf?.books?[index] as? Book
        }
    }
}
