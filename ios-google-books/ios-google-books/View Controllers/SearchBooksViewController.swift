//
//  SearchBooksViewController.swift
//  ios-google-books
//
//  Created by Conner on 8/22/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class SearchBooksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var searchBar: UISearchBar!
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return books.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BookSearchCell", for: indexPath)
    
    cell.textLabel?.text = books[indexPath.row].volumeInfo.title
    return cell
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }

    bookController.searchBooksViaAPI(searchTerm: searchTerm) { (books, error) in
      if let error = error {
        NSLog("error with fetching books via API: \(error)")
        return
      }
      self.books = books
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  let bookController = BookController()
  var books: [BookRepresentation] = []
}
