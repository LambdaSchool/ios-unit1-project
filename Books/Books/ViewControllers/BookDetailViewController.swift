//
//  BookDetailViewController.swift
//  Books
//
//  Created by Farhan on 9/26/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateViews()
    }
    
    func updateViews(){
        
        guard let book = book, let imageLink = book.thumbnail else {return}
        
        authorLabel.text = book.author
        ratingLabel.text = String(book.averageRating)
        publishedLabel.text = book.publishedDate
        
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
                self.coverImageView.image = image
            }
            }.resume()
        
    }
    
    @IBAction func dailyReminderSwitch(_ sender: Any) {
        
        guard let title = book?.title else {return}
        
        if reminderSwitch.isOn {
            
            localNotificationHelper.requestAuthorization { (flag) in
                
                if flag == true{
                    self.localNotificationHelper.scheduleDailyReminderNotification(with: title)
                }
                else {
                    return
                }
            }
            
        } else {
            localNotificationHelper.stopNotifications()
        }
        
    }
    
    // MARK: - Properties
    
    let localNotificationHelper = LocalNotificationHelper()
    
    var book: Book?
    
    //    var bookController: BookController?
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    
}
