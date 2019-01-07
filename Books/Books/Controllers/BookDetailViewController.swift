//
//  BookDetailViewController.swift
//  Books
//
//  Created by Sergey Osipyan on 1/4/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit


class BookDetailViewController: UIViewController {

    
    @IBOutlet var imageLink: [UIImageView]!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookDescription: UITextView!
    @IBOutlet weak var pageCountLabel: UILabel!
    
    var book: Book?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        
        guard let book = book else {return}
        
        bookTitle.text = book.volumeInfo.title
        subtitle.text = book.volumeInfo.subtitle
        if let author = book.volumeInfo.authors?.first {
            authorLabel.text = "Author: \(author)"
        }
        bookDescription.text = book.volumeInfo.description
        guard let url = URL(string: book.volumeInfo.imageLinks?.smallThumbnail ?? "No image"),
            let imageData = try? Data(contentsOf: url) else { return }
        bookImage.image = UIImage(data: imageData)
        if let pages =  book.volumeInfo.pageCount {
            pageCountLabel.text = "Page count: \(String(describing: pages))"
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

}
