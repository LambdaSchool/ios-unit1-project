//
//  BookDetailViewController.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    var book: Book?

    @IBOutlet weak var bookImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateViews()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - Utility Methods
    private func updateViews() {
        guard let book = book  else { return }
        
        title = book.title
        
        if let imageData = book.imageData {
            bookImageView.image = UIImage(data: imageData)
            bookImageView.alpha = 0.3
        }
        
        
        
    }
}
