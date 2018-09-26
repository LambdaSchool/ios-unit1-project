//
//  VolumeSearchTableViewController.swift
//  Book List
//
//  Created by Moin Uddin on 9/25/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import UIKit

class VolumeSearchTableViewController: UITableViewController, UISearchBarDelegate, SearchVolumeTableViewCellDelegate, VolumeControllerProtocol {
    func addVolume(volumeRep: VolumeRepresentation) {
        volumeController?.createVolume(title: volumeRep.volumeInfo.title, id: volumeRep.id, imageLink: (volumeRep.volumeInfo.imageLinks?.thumbnail)!)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        
        volumeController?.searchForVolumes(searchTerm: searchTerm) {(_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
        
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return volumeController?.searchedVolumes.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchVolumeCell", for: indexPath) as? SearchVolumeTableViewCell else { return UITableViewCell() }
        let volumeRep = volumeController?.searchedVolumes[indexPath.row]
        
        cell.volumeRep = volumeRep
        cell.delegate = self
        return cell
    }
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var volumeController: VolumeController?
    
}
