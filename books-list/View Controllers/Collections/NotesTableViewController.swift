//
//  NotesTableViewController.swift
//  books-list
//
//  Created by De MicheliStefano on 23.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    
    // MARK: - Properties
    
    var book: Book?
    var bookController: BookController?
    
    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reload(notification:)), name: Notification.Name("AddedPost"), object: nil)
    }

    @objc func reload(notification: Notification) {
        tableView.beginUpdates()
        guard let objectCount = book?.notes?.allObjects.count else { return }
        let indexPath = IndexPath(row: objectCount - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .left)
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book?.notes?.allObjects.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NotesTableViewCell

        guard let note = book?.notes?.allObjects[indexPath.row] as? Note else { return cell }
        
        cell.note = note

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let note = book?.notes?.allObjects[indexPath.row] as? Note,
            let book = book else { return }
        
        if editingStyle == .delete {
            bookController?.remove(note, from: book)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // TODO: insert editing style when adding new collection: https://www.youtube.com/watch?v=MC4mDQ7UqEE
        }    
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNoteDetail" {
            let vc = segue.destination as! NotesDetailViewController
            vc.book = book
            vc.bookController = bookController
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.note = book?.notes?.allObjects[indexPath.row] as? Note
            }
        }
    }

}
