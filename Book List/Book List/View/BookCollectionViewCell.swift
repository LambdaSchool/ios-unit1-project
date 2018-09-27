//
//  BookCollectionViewCell.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit

protocol BookCollectionViewCellDelegate: class {
    func deleteBook(_ book: Book)
}

class BookCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var book: Book? {
        didSet{
            updateViews()
        }
    }
    
    var isEditing: Bool = false {
        didSet {
            deleteButtonBackgroundView.isHidden = !isEditing
        }
    }
    
    weak var delegate: BookCollectionViewCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var deleteButtonBackgroundView: UIVisualEffectView!
    
    // MARK: - UI Methods
    @IBAction func deleteBook(_ sender: Any) {
        guard let book = book else { return }
        delegate?.deleteBook(book)
    }
    
    // MARK: - Utility Methods
    private func updateViews() {
        guard let book = book else { return }
        
        titleLabel.text = book.title
        if let imageData = book.thumbnailData {
            bookImageView.image = UIImage(data: imageData)
            titleLabel.text = nil
        }
        deleteButtonBackgroundView.layer.cornerRadius = deleteButtonBackgroundView.bounds.width / 2.0
        deleteButtonBackgroundView.layer.masksToBounds = true
        
        deleteButtonBackgroundView.isHidden = !isEditing
    }
    
}
