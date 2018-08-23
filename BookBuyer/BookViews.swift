//
//  BookViews.swift
//  BookBuyer
//
//  Created by William Bundy on 8/21/18.
//  Copyright © 2018 William Bundy. All rights reserved.
//


import Foundation
import UIKit

class BookshelfCell:UITableViewCell
{
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var volumeLabel: UILabel!
	var shelf:BookshelfStub! {
		didSet {
			nameLabel.text = shelf.title
			volumeLabel.text = "\(shelf.volumes.count)"
		}
	}
}

class ShelfListVC:UITableViewController
{
	var controller:BookController!
	override func viewDidLoad()
	{
		controller = App.bookController
		controller.fetchShelvesAndContents { (error) in
			print(error ?? "No error")
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return controller.shelves.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let defaultCell = tableView.dequeueReusableCell(withIdentifier: "ShelfCell", for: indexPath)
		guard let cell = defaultCell as? BookshelfCell else { return defaultCell }
		//cell.textLabel?.text = controller.shelves[indexPath.section].volumes[indexPath.row].title
		cell.shelf = controller.shelves[indexPath.row]
		return cell
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let dest = segue.destination as? BookListVC {
			if let cell = sender as? BookshelfCell {
				dest.shelf = cell.shelf
			}
		}
	}
}

class BookCell:UICollectionViewCell
{
	@IBOutlet weak var coverImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	var book:BookStub! {
		didSet {
			titleLabel.text = book.title

			if let thumb = book.smallThumb {
				coverImage.downloadImage(thumb)
			} else if let thumb = book.thumbnail {
				coverImage.downloadImage(thumb)
			}
		}
	}
}

class BookListVC:UICollectionViewController
{
	var shelf:BookshelfStub!

	override func viewWillAppear(_ animated: Bool) {
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return shelf.volumes.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath)
		guard let cell = defaultCell as? BookCell else { return defaultCell }
		cell.book = shelf.volumes[indexPath.item]
		return cell
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let dest = segue.destination as? BookDetailVC {
			if let cell = sender as? BookCell {
				dest.book = cell.book
			}
		}
	}
}

class BookDetailVC:UIViewController
{
	// we need to modify the text on this button based on
	// whether the book is owned or not.
	@IBOutlet weak var buyButton: UIBarButtonItem!

	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var coverImage: UIImageView!

	var book:BookStub!
	override func viewWillAppear(_ animated: Bool)
	{
		book = App.bookController.reloadBook(book)
		if book == nil {
			return
		}
		titleLabel.text = book.title
		descriptionLabel.text = book.details
		//TODO(will): Fix description label scrolling
		// it should scroll, but doesn't beacuse... constraints?
		// need to resize it at runtime, I guess?


		if let thumb = book.thumbnail {
			coverImage.downloadImage(thumb)
		} else if let thumb = book.smallThumb {
			coverImage.downloadImage(thumb)
		}
	}


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let dest = segue.destination as? BookReviewVC {
			dest.book = book
		}
	}

}

class BookReviewVC:UIViewController
{
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var reviewField: UITextView!
	var book:BookStub!
	override func viewWillAppear(_ animated: Bool)
	{
		titleLabel.text = book.title
		reviewField.text = book.review
	}

	@IBAction func saveReview(_ sender: Any)
	{
		guard let review = reviewField.text else { return }
		App.bookController.updateReview(book, review)
		navigationController?.popViewController(animated: true)
	}

}

// borrowed from simon's post
// with some... dumb fixes

let imageCache = NSCache<NSString, AnyObject>()
extension UIImageView
{
	func downloadImage(_ urlString: String, completion: @escaping CompletionHandler = EmptyHandler)
	{
		self.image = nil
		if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
			self.image = cachedImage
			completion(nil)
			return
		}

		var us = urlString
		if us.starts(with: "http:") {
			us.insert("s", at: us.index(of: ":")!)
		}
		guard let url = URL(string: us) else { return }

		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let error = error {
				App.handleError(completion, "Error getting image: \(error)")
				return
			}

			guard let data = data else {
				App.handleError(completion, "Error getting image: no data!")
				return
			}

			DispatchQueue.main.async {
				if let downloadedImage = UIImage(data: data) {
					imageCache.setObject(downloadedImage, forKey: urlString as NSString)
					self.image = downloadedImage
					completion(nil)
				}
			}
		}.resume()
	}
}
