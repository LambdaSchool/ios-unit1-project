//
//  SelectiveBookshelfTableViewController.swift
//  BookShelf
//
//  Created by Austin Cole on 1/4/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class SelectiveBookshelfTableViewController: UITableViewController {
    static let shared = SelectiveBookshelfTableViewController()
    private let reuseIdentifier = "Cell"
    var bookshelves: [Bookshelf]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bookshelves = Model.shared.bookshelves
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookshelves?.count ?? 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SelectiveBookshelfTableViewCell else {fatalError("Could not DQ cell.")}
        cell.bookshelfNameLabel.text = bookshelves?[indexPath.row].name
        switch bookshelves?[indexPath.row].books?.count {
        case nil:
        return cell
        case 1:
            cell.bookshelfBookImageCenter.image = Model.shared.getImage(string: (bookshelves?[indexPath.row].books?[0].imageLinks?.smallThumbnail)!)
        case 2:
            cell.bookshelfBookImageCenter.image = Model.shared.getImage(string: (bookshelves?[indexPath.row].books?[0].imageLinks?.smallThumbnail)!)
            cell.bookshelfBookImageRight.image = Model.shared.getImage(string: (bookshelves?[indexPath.row].books?[1].imageLinks?.smallThumbnail)!)
        default:
            cell.bookshelfBookImageCenter.image = Model.shared.getImage(string: (bookshelves?[indexPath.row].books?[0].imageLinks?.smallThumbnail)!)
            cell.bookshelfBookImageRight.image = Model.shared.getImage(string: (bookshelves?[indexPath.row].books?[1].imageLinks?.smallThumbnail)!)
            cell.bookshelfBookImageLeft.image = Model.shared.getImage(string: (bookshelves?[indexPath.row].books?[2].imageLinks?.smallThumbnail)!)
        }
        return cell
    }
    
}
