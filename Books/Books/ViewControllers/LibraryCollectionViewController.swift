//
//  LibraryCollectionViewController.swift
//  Books
//
//  Created by Farhan on 9/26/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "BookCell"

class LibraryCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: FetchedResults Controller
    
    lazy var fetchedResultsController: NSFetchedResultsController<Book> = {
        
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
        
    }()
    
    // MARK: - fetched results delegate methods
    
    private var blockOperations: [BlockOperation] = []
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        let op: BlockOperation
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            op = BlockOperation { self.collectionView?.insertItems(at: [newIndexPath]) }
        case .delete:
            guard let indexPath = indexPath else { return }
            op = BlockOperation { self.collectionView?.deleteItems(at: [indexPath]) }
        case .update:
            guard let indexPath = indexPath else { return }
            op = BlockOperation { self.collectionView?.reloadItems(at: [indexPath]) }
        case .move:
            guard let indexPath = indexPath,  let newIndexPath = newIndexPath else { return }
            op = BlockOperation { self.collectionView?.moveItem(at: indexPath, to: newIndexPath) }
        }
        
        blockOperations.append(op)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        var op: BlockOperation?
        switch type {
        case .insert:
            op = BlockOperation { self.collectionView?.insertSections(IndexSet(integer: sectionIndex)) }
        case .delete:
            op = BlockOperation { self.collectionView?.deleteSections(IndexSet(integer: sectionIndex)) }
        default:
            break
        }
        
        guard let newOp = op else { return }
        blockOperations.append(newOp)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({
            self.blockOperations.forEach { $0.start() }
        }, completion: { finished in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return fetchedResultsController.sections?[section].numberOfObjects ?? 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BookCollectionViewCell else {return UICollectionViewCell()}
    
        cell.book = fetchedResultsController.object(at: indexPath)
    
        return cell
    }

}
