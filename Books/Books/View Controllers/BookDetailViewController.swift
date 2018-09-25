//
//  BookDetailViewController.swift
//  Books
//
//  Created by Daniela Parra on 9/24/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    private func updateViews() {
        guard let volume = volume else { return }
        
        //book image from string url?
        bookTitleLabel.text = volume.title
        bookTitleLabel.text = volume.subtitle
        authorsLabel.text = volume.authors
        reviewTextView.text = volume.myReview
        
        if volume.hasRead {
            hasReadButton.setTitle("Have Read", for: .normal)
        } else {
            hasReadButton.setTitle("Haven't Read", for: .normal)
        }
        
        //set segmented controller to myRating
    }
    
    @IBAction func moveToAnotherBookshelf(_ sender: Any) {
    }
    
    @IBAction func changeHasRead(_ sender: Any) {
    }
    
    // MARK: - Properties
    
    var volume: Volume? {
        didSet {
            updateViews()
        }
    }
    //add volumecontroller
    //add bookshelf?

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookSubtitleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var hasReadButton: UIButton!
    @IBOutlet weak var reviewSegmentedControl: UISegmentedControl!
    @IBOutlet weak var reviewTextView: UITextView!
    
}
