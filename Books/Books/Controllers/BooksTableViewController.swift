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
    
    var book: [BookModel] = [] {
        didSet {
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
       tableView.reloadData()
        DispatchQueue.main.async {
            ModelBookshelf.shared.bookPerformSearch()
        }
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            if let error = error {
                NSLog("Authorization failed: \(error)")
                return
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.numberOfBooks()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BookTableViewCell else { fatalError("no cell") }
        
        guard let book = Model.shared.book else {return cell}
        
       cell.testLabel?.text = book.items[indexPath.row].volumeInfo.subtitle
        
        cell.bookLabel?.text = book.items[indexPath.row].volumeInfo.title
        
        
        guard let url = URL(string: book.items[indexPath.row].volumeInfo.imageLinks?.smallThumbnail ?? "No image"),
            let imageData = try? Data(contentsOf: url) else { return cell }
       
        cell.bookImage.image = UIImage(data: imageData)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search" {
            guard let indexPath = tableView.indexPathForSelectedRow
                else {return}
            let destination = segue.destination as! BookDetailViewController
            let book = Model.shared.book?.items[indexPath.row]
            destination.book = book
        }
    }
    
    func searchBarSearchButtonClicked(_  searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty
            else {return}
        searchBar.text = ""
        
        Model.shared.performSearch(with: searchTerm) { (error) in
           // Model.shared.clearBooks()
            if let error = error {
               
                NSLog("Error fetching data: \(error)")
                return
            }
            DispatchQueue.main.async {
                Model.shared.clearBooks()
               
                self.tableView.reloadData()
                
            }
        
    }
}
    
}


