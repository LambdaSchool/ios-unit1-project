//
//  BookshelfVolumeDetailViewController.swift
//  Book List
//
//  Created by Moin Uddin on 9/25/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import UIKit

class BookshelfVolumeDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    func checkhasRead(volume: Volume) {
        if volume.hasRead == true {
            hasRead = true
        } else {
            hasRead = false
        }
    }
    
    
    
    func updateViews() {
        guard let volume = volume else { return }
        guard let volumeTitle = volume.title,
        let volumeReview = volume.review else { return }
        
        checkhasRead(volume: volume)
        
        
        title = volume.title
        detailTitleLabel.text = volumeTitle
        reviewTextView.text = volumeReview
        volume.hasRead ? hasReadButton.setTitle("NOT READ", for: .normal) : hasReadButton.setTitle("HAS READ", for: .normal)
        
        guard let imageLink = volume.imageLink else { return }
        let imageUrl = URL(string: imageLink)!
        
        URLSession.shared.dataTask(with: imageUrl) { (data, _, error) in
            if let error = error {
                NSLog("Error with request to retrieve image: \(error)")
                return
            }
            guard let data = data else {
                NSLog("There is an error with the data")
                return
            }
            DispatchQueue.main.async {
                self.volumeImage.image = UIImage(data: data)
            }
            }.resume()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var volumeImage: UIImageView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var hasReadButton: UIButton!
    @IBOutlet weak var detailTitleLabel: UILabel!
    
    

    var hasRead: Bool?
    

    
    @IBAction func toggleHasRead(_ sender: Any) {

        if hasReadButton.currentTitle == "HAS READ" {
            hasRead = true
            hasReadButton.setTitle("NOT READ", for: .normal)
        } else if hasReadButton.currentTitle == "NOT READ" {
            hasRead = false
            hasReadButton.setTitle("HAS READ", for: .normal)
        }
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        guard let title = detailTitleLabel.text,
            let review = reviewTextView.text,
            let volume = volume else { return }
        bookshelfController?.updateVolumeInBookshelf(volume: volume, hasRead: hasRead, review: review)
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
    
    var volume: Volume? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    var bookshelfController: BookshelfController?

}
