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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    private func updateViews() {
        guard let volume = volume, isViewLoaded else { return }
        
        bookTitleLabel.text = volume.title
        bookSubtitleLabel.text = volume.subtitle
        authorsLabel.text = volume.authors
        reviewTextView.text = volume.myReview
        
        if volume.hasRead {
            hasReadButton.setTitle("Have Read", for: .normal)
        } else {
            hasReadButton.setTitle("Haven't Read", for: .normal)
        }
        
        guard let thumbnailString = volume.image else { return }
        let url = URL(string: thumbnailString)!
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error: \(error)")
            }
            
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.bookImageView.image = image
            }
        }.resume() 
    }
    
    @IBAction func saveUpdates(_ sender: Any) {
        guard let volume = volume,
            let myReview = reviewTextView.text else { return }
        
        volumeController?.updateVolumeReview(volume: volume, myReview: myReview)
    }
    
    @IBAction func changeHasRead(_ sender: Any) {
        guard let volume = volume else { return }

        volumeController?.changeVolumeReadStatus(volume: volume, oldStatus: volume.hasRead)
        updateViews()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoveToBookshelf" {
            guard let destinationVC = segue.destination as? PickBookshelfTableViewController else { return }
            //Should I unwrap this volume?
            destinationVC.volume = volume
            destinationVC.volumeController = volumeController
        }
    }
    
    // MARK: - Properties
    
    var volume: Volume? {
        didSet {
            updateViews()
        }
    }
    var bookshelf: Bookshelf?
    var volumeController: VolumeController?

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookSubtitleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var hasReadButton: UIButton!
    @IBOutlet weak var reviewTextView: UITextView!
    
}
