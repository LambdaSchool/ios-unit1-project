//
//  PossibleBookshelvesTableViewController.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/27/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit
import CoreData

class PossibleBookshelvesTableViewController: UITableViewController {
    
    // MARK: - Properties
    var book: Book?
    
    var onBookshelf: [Bookshelf] = []
    var notOnBookshelf: [Bookshelf] = []

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBookshelves()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if onBookshelf.count > 0 {
                return onBookshelf.count == 1 ? "On This Bookshelf" : "On These Bookshelves"
            } else {
                return nil
            }
        } else {
            if notOnBookshelf.count > 0 {
                return notOnBookshelf.count == 1 ? "Not On This Bookshelf" : "Not On These BookShelves"
            } else {
                return nil
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return onBookshelf.count
        } else {
            return notOnBookshelf.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PossibleBookShelfCell", for: indexPath)
        let bookshelf = bookshelfFor(indexPath: indexPath)
        
        cell.textLabel?.text = bookshelf.title?.capitalized
        cell.backgroundColor = .clear

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let removed = onBookshelf.remove(at: indexPath.row)
            notOnBookshelf.append(removed)
            tableView.reloadData()
        } else {
            let removed = notOnBookshelf.remove(at: indexPath.row)
            onBookshelf.append(removed)
            if let book = book {
                book.addToBookshelves(removed)
                removed.addToBooks(book)
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - Utility Methods
    private func bookshelfFor(indexPath: IndexPath) -> Bookshelf {
        if indexPath.section == 0 {
            return onBookshelf[indexPath.row]
        } else {
            return notOnBookshelf[indexPath.row]
        }
    }
    
    private func loadBookshelves() {
        let fetchRequest: NSFetchRequest<Bookshelf> = Bookshelf.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        let predicate = NSPredicate(format: "editable = YES")
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        if let context = book?.managedObjectContext, let bookshelvebooks = book?.bookshelves {
            context.performAndWait {
                do {
                    let bookshelves = try context.fetch(fetchRequest)
                    
                    for bookshelf in bookshelves {
                        if bookshelvebooks.contains(bookshelf) {
                            onBookshelf.append(bookshelf)
                        } else {
                            notOnBookshelf.append(bookshelf)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    NSLog("Error fetching bookshelves: \(error)")
                }
            }
        }
    }

}
