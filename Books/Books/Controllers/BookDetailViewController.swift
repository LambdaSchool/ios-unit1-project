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
    @IBAction func addBookshelf(_ sender: Any) {
    }
    
    var book: Book?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       UpdaiteView()
        
       
        }
    
    
    func UpdaiteView() {
        
        if let book = book {
        DispatchQueue.main.async {
            if let title = book.volumeInfo.title {
        self.bookTitle.text = title
        self.navigationItem.title = title
            } else {
                self.bookTitle.text = "No Title"
            }
            if let subtitle = book.volumeInfo.subtitle {
        self.subtitle.text = subtitle
            } else {
                self.subtitle.text = ""
            }
        if let author = book.volumeInfo.authors?.first {
            self.authorLabel.text = "Author: \(author)"
        } else {
            self.authorLabel.text = "No Author"
            }
            if let description = book.volumeInfo.description {
        self.bookDescription.text = description
            } else {
                self.bookDescription.text = "No Description"
            }
        guard let url = URL(string: book.volumeInfo.imageLinks?.smallThumbnail ?? "No image"),
            let imageData = try? Data(contentsOf: url) else { return }
        self.bookImage.image = UIImage(data: imageData)
        if let pages =  book.volumeInfo.pageCount {
            self.pageCountLabel.text = "Page count: \(String(describing: pages))"
        } else {
            self.pageCountLabel.text = ""
            }
           
            }
        } else {
             DispatchQueue.main.async {
            self.bookTitle.text = ""
            self.subtitle.text = ""
            self.authorLabel.text = ""
            self.bookDescription.text = ""
            self.pageCountLabel.text = ""
            self.bookImage.image = nil
    }
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
