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
    
    var book: Book?
    
    var onBookshelf: [Bookshelf] = []
    var notOnBookshelf: [Bookshelf] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    @IBAction func saveBookshelves(_ sender: Any) {
        guard let book = book else { return }
        
        for bookshelf in onBookshelf {
            book.addToBookshelves(bookshelf)
            bookshelf.addToBooks(book)
        }
        
        for bookshelf in notOnBookshelf {
            book.removeFromBookshelves(bookshelf)
            bookshelf.removeFromBooks(book)
        }
        
        navigationController?.popViewController(animated: true)
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
            tableView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func bookshelfFor(indexPath: IndexPath) -> Bookshelf {
        if indexPath.section == 0 {
            return onBookshelf[indexPath.row]
        } else {
            return notOnBookshelf[indexPath.row]
        }
    }

}
