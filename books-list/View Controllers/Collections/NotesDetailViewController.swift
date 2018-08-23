//
//  NotesDetailViewController.swift
//  books-list
//
//  Created by De MicheliStefano on 23.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class NotesDetailViewController: UIViewController {

    var book: Book?
    var note: Note? {
        didSet {
            updateViews()
        }
    }
    var bookController: BookController?
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func save(_ sender: Any) {
        if let book = book,
            let note = note,
            let text = notesTextView.text {
            
            bookController?.update(note, in: book, with: text)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        notesTextView?.text = note?.text
        title = book?.title
    }
    
}
