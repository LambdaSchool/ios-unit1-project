//
//  BooksTableViewController.swift
//  Books
//
//  Created by Sergey Osipyan on 1/3/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit

class BooksTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var book: BookModel?
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
           
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            if let error = error {
                NSLog("Authorization failed: \(error)")
                return
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BookTableViewCell else { fatalError("no cell") }
        
        let book = Model.shared.bookAtIndex(at: indexPath)
        
        guard let booking = book.items[indexPath.row].volumeInfo.subtitle else { return cell }
        cell.testLabel?.text = booking
        
        cell.bookLabel?.text = book.items[indexPath.row].volumeInfo.title
        
        
        guard let url = URL(string: book.items[indexPath.row].volumeInfo.imageLinks?.smallThumbnail ?? "No image"),
            let imageData = try? Data(contentsOf: url) else { return cell }
       
        cell.bookImage.image = UIImage(data: imageData)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Model.shared.deleteBook(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search" {
            guard let indexPath = tableView.indexPathForSelectedRow
                else {return}
            let destination = segue.destination as! BookDetailViewController
            let book = Model.shared.book(at: indexPath.row).items[indexPath.row]
            destination.book = book
        }
    }
    
    
    
    func update() {
        
        //guard let indexPath = self.tableView.indexPathForSelectedRow else {return}
        
            for _ in 1...8 {
                Model.shared.addNewBook()
            }
//
//        if let book = self.book {
//       self.bookTableViewCell.bookLabel.text = book.items[indexPath.row].volumeInfo.title
           tableView.reloadData()
        
            }
    
    
    func searchBarSearchButtonClicked(_  searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty
            else {return}
        searchBar.text = ""
        
        Model.shared.performSearch(with: searchTerm) { (error) in
            //Model.shared.clearBooks()
            if let error = error {
               
                NSLog("Error fetching data: \(error)")
                return
            }
            DispatchQueue.main.async {
                Model.shared.clearBooks()
                 self.update()
                self.tableView.reloadData()
                self.searchBar.endEditing(true)
                //self.update()
                
                // Model.shared.addNewBook()
            }
        
    }
}
}


