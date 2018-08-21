//
//  AddToCollectionsTableViewCell.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol AddToCollectionsDelegate {
    func addToCollection(_ book: Book)
}

class AddToCollectionsTableViewCell: UITableViewCell {

    // MARK: - Properties
    var collection: Collection? {
        didSet {
            updateViews()
        }
    }
    var book: Book?
    var delegate: AddToCollectionsDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    
    // MARK: - Methods
    
    @IBAction func addToCollection(_ sender: Any) {
        guard let book = book else { return }
        delegate?.addToCollection(book)
    }
    
    private func updateViews() {
        titleLabel?.text = collection?.title
        buttonLabel?.setTitle(collection?.books?.contains(book as Any) != nil ? "Added" : "Add", for: .normal)
    }

}
