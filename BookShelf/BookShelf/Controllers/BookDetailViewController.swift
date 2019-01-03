//
//  BookDetailViewController.swift
//  BookShelf
//
//  Created by Austin Cole on 1/2/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    var book: VolumeInfo?
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var userReviewTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var insertButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var hasReadLabel: UILabel!
    @IBOutlet weak var hasReadSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookImageView.image = UIImage(named: "book_image_not_available")
        if let imageURL = book?.volumeInfo.imageLinks?.smallThumbnail{
            guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
            guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
            bookImageView.image = UIImage(data: imageData)
        }
            
        else if let imageURL = book?.volumeInfo.imageLinks?.thumbnail {
            guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
            guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
            bookImageView.image = UIImage(data: imageData)
        }
        bookTitleLabel.text = book?.volumeInfo.title
        // Do any additional setup after loading the view.
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
