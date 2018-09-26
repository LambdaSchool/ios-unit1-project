//
//  BookCollectionViewCell.swift
//  Books
//
//  Created by Farhan on 9/24/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    var book: Book?{
        didSet{
            updateViews()
        }
    }
    
    func updateViews(){
        
        guard let book = book, let imageLink = book.thumbnail else {return}
        let imageURL = URL(string: imageLink)!
        
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                NSLog("Error getting image: \(error)")
                return
            }
            guard let data = data else {
                NSLog("Data Corrupted")
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
            }.resume()
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
}
