//
//  BookDetailViewController.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit
import CoreData

class BookDetailViewController: UIViewController, UIScrollViewDelegate {
    
    var book: Book? {
        didSet {
            updateViews()
        }
    }
    
    var bookshelfController: BookshelfController?
    
    var objectID: NSManagedObjectID? {
        didSet{
            if let objectID = objectID {
                childContext.performAndWait {
                    book = childContext.object(with: objectID) as? Book
                }
            }
        }
    }
    
    lazy var childContext: NSManagedObjectContext = {
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = CoreDataStack.shared.mainContext
        return childContext
    }()
    
    var titleString = ""

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContainer: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var bookDescriptionLabel: UILabel!
    @IBOutlet weak var bookshelvesLabel: UILabel!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        updateViews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        view.updateConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerViewHeightConstraint.constant = stackView.frame.height + 16
    }
    
    @IBAction func saveBook(_ sender: Any) {
        guard let book = book, let bookshelves = book.bookshelves else { return }
        for bookshelf in bookshelves {
            if let bookshelf = bookshelf as? Bookshelf {
                bookshelfController?.post(book: book, to: bookshelf)
            }
        }
        
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

    
    // MARK: - Utility Methods
    private func updateViews() {
        title = titleString
        if title == "" { navigationItem.largeTitleDisplayMode = .never }
        
        guard let book = book, isViewLoaded else { return }
        
        titleLabel.text = book.title
        authorLabel.text = book.author
        if book.pageCount < 1 {
            pageCountLabel.isHidden = true
        } else {
            pageCountLabel.text = "\(book.pageCount) pages"
        }
        bookDescriptionLabel.text = book.bookDescription
        bookshelvesLabel.text = book.bookshelfList
        
        if let imageData = book.imageData {
            bookImageView.image = UIImage(data: imageData)
            bookImageView.alpha = 0.8
            
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = bookImageView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            bookImageView.addSubview(blurEffectView)
        }
        
    }
}
