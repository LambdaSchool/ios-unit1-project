//
//  BookDetailViewController.swift
//  Books
//
//  Created by Sergey Osipyan on 1/4/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookDescription: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let book = Model.shared.book else {return}
        bookTitle.text = book.items[0].volumeInfo.title
        subtitle.text = book.items[0].volumeInfo.subtitle
        authorLabel.text = "\(String(describing: book.items[0].volumeInfo.authors))"
        bookDescription.text = book.items[0].volumeInfo.description
        guard let url = URL(string: book.items[0].volumeInfo.imageLinks?.thumbnail ?? "No image"),
            let imageData = try? Data(contentsOf: url) else { return }
        bookImage.image = UIImage(data: imageData)
        
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
