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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return books.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BookSearchCell", for: indexPath) as! BookSearchTableViewCell
    
    cell.book = books[indexPath.row]
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "BookSearchDetailSegue" {
      if let vc = segue.destination as? BookSearchDetailViewController {
        vc.bookController = bookController
        if let indexPath = self.tableView.indexPathForSelectedRow {
          self.tableView.deselectRow(at: indexPath, animated: true)
          vc.book = books[indexPath.row]
        }
      }
    }
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
