//
//  BookDetailViewController.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit
import CoreData

class BookDetailViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    // MARK: - Properties
    var book: Book? {
        didSet {
            updateViews()
        }
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = CoreDataStack.shared.container.persistentStoreCoordinator
        return context
    }()
    
    var bookshelfController: BookshelfController?
    let bookController = BookController()
    var bookshelfTableView: PossibleBookshelvesTableViewController?
    
    var titleString = ""
    var activeView: UITextView?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    var reset: Bool = true

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContainer: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var bookDescriptionLabel: UILabel!
    @IBOutlet weak var bookshelvesLabel: UILabel!
    @IBOutlet weak var reviewTextField: UITextView!
    @IBOutlet weak var hasReadSwitch: UISwitch!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        reviewTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        updateViews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerViewHeightConstraint.constant = stackView.frame.height + 60
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent && reset {
            book?.managedObjectContext?.reset()
        }
    }
    
    // MARK: - UI Methods
    @IBAction func saveBook(_ sender: Any) {
        guard let book = book, let bookshelves = book.bookshelves, let context = book.managedObjectContext else { return }
        if let review = reviewTextField.text {
            book.bookReview = review
        }
        
        book.hasRead = hasReadSwitch.isOn
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving child context: \(error)")
        }
        
        for bookshelf in bookshelves {
            if let bookshelf = bookshelf as? Bookshelf {
                bookshelfController?.add(book: book, to: bookshelf)
            }
        }
        if let bookshelfTableView = bookshelfTableView {
            for bookshelf in bookshelfTableView.notOnBookshelf {
                bookController.remove(book: book, from: bookshelf)
            }
        }
        
        reset = false
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UI Text Field
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        lastOffset = scrollView.contentOffset
        
        activeView = textView
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        activeView = nil
        
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.containerViewHeightConstraint.constant += self.keyboardHeight
            })
            // move if keyboard hide input field
            let distanceToBottom = self.scrollView.frame.size.height - (activeView?.frame.origin.y)! - (activeView?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
            if collapseSpace < 0 {
                return
            }
            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.containerViewHeightConstraint.constant -= self.keyboardHeight
            self.scrollView.contentOffset = self.lastOffset
        }
        keyboardHeight = nil
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditBookshelvesEmbedSegue" {
            let desintationVC = segue.destination as! PossibleBookshelvesTableViewController
            bookshelfTableView = desintationVC
            desintationVC.book = book
        }
    }

    
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
        hasReadSwitch.isOn = book.hasRead
        reviewTextField.text = book.bookReview
        
        cardView.layer.cornerRadius = 20
        
        
        if let imageData = book.imageData {
            bookImageView.image = UIImage(data: imageData)
            bookImageView.alpha = 0.9
            
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = bookImageView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            bookImageView.addSubview(blurEffectView)
        }
        
    }
}
