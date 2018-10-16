//
//  BookSearchTableViewController.swift
//  Books
//
//  Created by Daniela Parra on 9/24/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class BookSearchTableViewController: UITableViewController, UISearchBarDelegate {

    //Set up this table view controller as the search bar's delegate.
    override func viewDidLoad() {
        super.viewDidLoad()

        bookSearchBar.delegate = self
    }
    
    //Clear volume search results when no longer searching.
    override func viewWillAppear(_ animated: Bool) {
        if bookSearchBar.text == "" {
            volumeController?.volumeSearchResults = []
        }
    }
    
    //Perform search with given search term after clicking search button.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = bookSearchBar.text else { return }
        
        volumeController?.searchBooks(searchTerm: searchTerm) { (error) in
            if let error = error {
                NSLog("Error: \(error)")
                return
            }
            //Ensure it displays the volume search results.
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    
    //Set up the number of rows in section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return volumeController?.volumeSearchResults.count ?? 0
    }
    
    //Set up custom cell based on index path.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookResultsTableViewCell else { return UITableViewCell()}
        
        //Pass variables to custom cell to display information.
        cell.volumeRepresentation = volumeController?.volumeSearchResults[indexPath.row]
        cell.volumeController = volumeController

        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Set up the next view controller (Pick Bookshelf TVC).
        if segue.identifier == "PickBookshelf" {
            guard let destinationVC = segue.destination as? PickBookshelfTableViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            //Pass these variables to the next view controller.
            destinationVC.volumeRepresentation = volumeController?.volumeSearchResults[indexPath.row]
            destinationVC.volumeController = volumeController
        }
    }
    
    // MARK: - Properties
    
    var volumeController: VolumeController?

    @IBOutlet weak var bookSearchBar: UISearchBar!
    
}
