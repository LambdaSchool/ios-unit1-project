//
//  BookDetailViewController.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    var book: Book?

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateViews()
    }
    
    @IBAction func saveBook(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - Utility Methods
    private func updateViews() {
        guard let book = book  else { return }
        
        title = (book.title?.count ?? 20) < 20 ? book.title : "Edit Book"
        titleLabel.text = book.title
        authorLabel.text = book.author
        pageCountLabel.text = "\(book.pageCount)"
        descriptionTextView.text = book.bookDescription
        
        if let imageData = book.imageData {
            bookImageView.image = UIImage(data: imageData)
            bookImageView.alpha = 0.2
        }
        
        
        
    }
}
