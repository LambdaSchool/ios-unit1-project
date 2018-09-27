//
//  MyBookshelvesTableViewController.swift
//  Books
//
//  Created by Daniela Parra on 9/24/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import CoreData

class MyBookshelvesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            if let error = error {
                NSLog("Authorization failed: \(error)")
                return
            }
        }
        
//        bookshelfController.fetchAllBookshelves { (_) in
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookshelfDetailCell", for: indexPath) as? BookshelfTableViewCell else { return UITableViewCell() }

        cell.registerCollectionView(datasource: self)
        
//        let bookshelfRep = bookshelfController.bookshelfRepresentations[indexPath.row]
        cell.bookshelf = fetchedResultsController.object(at: indexPath)
        cell.bookshelfController = bookshelfController
        cell.volumeController = bookshelfController.volumeController

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchBooks" {
            guard let destinationVC = segue.destination as? BookSearchTableViewController else { return }
            
            destinationVC.bookshelfController = bookshelfController
            destinationVC.volumeController = bookshelfController.volumeController
        }
    }
    
    // MARK: - Properties
    
    var bookshelf: Bookshelf?
    let bookshelfController = BookshelfController()
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

extension UITableViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        
        // Configure the cell
        
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
//    var bookshelf: Bookshelf?
//    var bookshelfController: BookshelfController?
//    var volumeController: VolumeController?
    
}
