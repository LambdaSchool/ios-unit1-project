//
//  BookDetailViewController.swift
//  Books
//
//  Created by Daniela Parra on 9/24/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import Photos

class BookDetailViewController: UIViewController {

    private func updateViews() {
        guard let volume = volume else { return }
        
        bookTitleLabel.text = volume.title
        bookTitleLabel.text = volume.subtitle
        authorsLabel.text = volume.authors
        reviewTextView.text = volume.myReview
        
        if volume.hasRead {
            hasReadButton.setTitle("Have Read", for: .normal)
        } else {
            hasReadButton.setTitle("Haven't Read", for: .normal)
        }
        
        displayImage(volume: volume)
        
        //set segmented controller to myRating
    }
    
    private func displayImage(volume: Volume) {
        let url = URL(string: volume.image!)
        
        do {
            let data = try Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.bookImageView.image = UIImage(data: data)
            }
        } catch {
            NSLog("Error creating image data from url: \(error)")
        }
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
    var volumeController: VolumeController?
    var bookshelfController: BookshelfController?

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookSubtitleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var hasReadButton: UIButton!
    @IBOutlet weak var reviewSegmentedControl: UISegmentedControl!
    @IBOutlet weak var reviewTextView: UITextView!
    
}
