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
    
    
    
    func updateViews() {
        guard let volume = volume else {
            return
        }
        title = volume.title
        //titleLabel.text = volume.title
        
        //volume.hasRead ? hasReadButton.setTitle("NOT READ", for: .normal) : hasReadButton.setTitle("HAS READ", for: .normal)
        
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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var volumeImage: UIImageView!
    
    @IBOutlet weak var reviewTextView: UITextView!
    
    @IBOutlet weak var hasReadButton: UIButton!
    

    var hasRead: Bool?
    
    @IBAction func toggleHasRead(_ sender: Any) {

        if hasReadButton.currentTitle == "HAS READ" {
            hasRead = false
            hasReadButton.setTitle("NOT READ", for: .normal)
        } else if hasReadButton.currentTitle == "NOT READ" {
            hasRead = true
            hasReadButton.setTitle("HAS READ", for: .normal)
        }
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        guard let title = titleLabel.text,
            let review = reviewTextView.text,
            let hasRead = hasRead,
            let volume = volume else { return }
        
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
            updateViews()
        }
    }

}
