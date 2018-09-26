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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = bookSearchBar.text else { return }
        
        volumeController.searchBooks(searchTerm: searchTerm) { (error) in
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
        // #warning Incomplete implementation, return the number of rows
        return volumeController.volumes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookResultsTableViewCell else { return UITableViewCell()}

        let volumeRepresentation = volumeController.volumes[indexPath.row]
        cell.volume = Volume(volumeRepresentation: volumeRepresentation)

        return cell
    }
    
    // MARK: - Properties
    
    let volumeController = VolumeController()

    @IBOutlet weak var bookSearchBar: UISearchBar!
    
}
