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
 
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
         Model.shared.addNewBook()
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.numberOfBooks()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BookTableViewCell else { fatalError("no cell") }
        
        let book = Model.shared.books[indexPath.row]
        
        cell.testLabel.text = "Authors \(String(describing: book.items[0].volumeInfo.subtitle))"
        
            cell.bookLabel.text = book.items[0].volumeInfo.title
        guard let url = URL(string: book.items[0].volumeInfo.imageLinks?.thumbnail ?? "No image"),
            let imageData = try? Data(contentsOf: url) else { return cell }
        cell.bookImage.image = UIImage(data: imageData)
      

        return cell
    }
    
    func searchBarSearchButtonClicked(_  searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty
            else {return}
        searchBar.text = ""
        tableView.reloadData()
        Model.shared.performSearch(with: searchTerm) { (error) in
            //Model.shared.clearBooks()
            if let error = error {
                NSLog("Error fetching data: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
              
            }
        }
    }
}



