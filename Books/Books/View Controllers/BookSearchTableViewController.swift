//
//  BookSearchTableViewController.swift
//  Books
//
//  Created by Daniela Parra on 9/24/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class BookSearchTableViewController: UITableViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        bookSearchBar.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //Sometimes causes an issue
        volumeController?.volumeSearchResults = []
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = bookSearchBar.text else { return }
        
        volumeController?.searchBooks(searchTerm: searchTerm) { (error) in
            if let error = error {
                NSLog("Error: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return volumeController?.volumeSearchResults.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookResultsTableViewCell else { return UITableViewCell()}

        cell.volumeRepresentation = volumeController?.volumeSearchResults[indexPath.row]
        cell.bookshelfController = bookshelfController
        cell.volumeController = volumeController

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickBookshelf" {
            guard let destinationVC = segue.destination as? PickBookshelfTableViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            destinationVC.volumeRepresentation = volumeController?.volumeSearchResults[indexPath.row]
            destinationVC.bookshelfController = bookshelfController
            destinationVC.volumeController = volumeController
        }
    }
    
    // MARK: - Properties
    
    var bookshelfController: BookshelfController?
    var volumeController: VolumeController?

    @IBOutlet weak var bookSearchBar: UISearchBar!
    
}
