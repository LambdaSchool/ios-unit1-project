//
//  PickBookshelfTableViewController.swift
//  Books
//
//  Created by Daniela Parra on 9/24/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import CoreData

class PickBookshelfTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func pickBookshelf(_ sender: Any) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        let bookshelf = fetchedResultsController.object(at: indexPath)
        
        if let volumeRepresentation = volumeRepresentation {
            volumeController?.createVolume(from: volumeRepresentation, bookshelf: bookshelf)
        } else if let volume = volume {
            volumeController?.moveVolume(volume: volume, from: bookshelf, to: bookshelf)
        }
        
        navigationController?.popViewController(animated: true)
    }
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookshelfCell", for: indexPath)
        
        let bookshelf = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = bookshelf.title

        return cell
    }
    
    
    

    // MARK: - Properties
    
    var volumeRepresentation: VolumeRepresentation?
    var volume: Volume?
    var oldBookshelf: Bookshelf?
    var volumeController: VolumeController?
    lazy var fetchedResultsController: NSFetchedResultsController<Bookshelf> = {
        let fetchRequest: NSFetchRequest<Bookshelf> = Bookshelf.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()

}
