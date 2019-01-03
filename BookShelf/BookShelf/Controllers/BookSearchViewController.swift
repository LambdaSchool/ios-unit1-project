//
//  BookSearchViewController.swift
//  BookShelf
//
//  Created by Austin Cole on 1/3/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class BookSearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var bookSearchBar: UISearchBar!
    @IBOutlet weak var containerView: UIView!
    
    var bookSearchCVC: BookSearchCollectionViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        bookSearchBar.delegate = self
        Model.shared.createBookShelves()
        // Do any additional setup after loading the view.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = bookSearchBar.text else{return}
        Model.shared.searchForBooks(searchTerm: searchTerm) {
        }
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
