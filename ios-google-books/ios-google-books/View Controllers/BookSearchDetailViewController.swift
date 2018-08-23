//
//  BookSearchDetailViewController.swift
//  ios-google-books
//
//  Created by Conner on 8/22/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class BookSearchDetailViewController: UIViewController {

  @IBOutlet var bookTitleLabel: UILabel!
  @IBOutlet var bookAuthorLabel: UILabel!
  @IBOutlet var bookSynopsisLabel: UILabel!
  @IBOutlet var imageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let book = book {
      if let image = book.volumeInfo.imageLinks?.smallThumbnail {
        let url = URL(string: image)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

          if error != nil {
            print(error!)
            return
          }

          DispatchQueue.main.async {
            self.imageView.image = UIImage(data: data!)
          }
        }).resume()
      }

      bookTitleLabel.text = book.volumeInfo.title

      if let author = book.volumeInfo.authors {
        bookAuthorLabel.text = author[0]
      }

      bookSynopsisLabel.text = book.volumeInfo.description
    }
  }

  @IBAction func saveToRead(_ sender: Any) {
    if let book = book {
      if let author = book.volumeInfo.authors {
        
        guard let image = imageView.image,
          let imageData = UIImagePNGRepresentation(image) as NSData? else { return }
        
        bookController?.createBook(title: book.volumeInfo.title,
                                   author: author[0],
                                   synopsis: book.volumeInfo.description ?? "",
                                   id: book.id,
                                   thumbnail: imageData)
      }
      
      do {
        try bookController?.saveToPersistentStore()
      } catch {
        NSLog("Error saving book from API search to Core Data")
      }

      self.tabBarController?.selectedIndex = 0
      self.navigationController?.popViewController(animated: true)
    }
  }

  var book: BookRepresentation?
  var bookController: BookController?
}
