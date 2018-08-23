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

			print(book.smallThumb ?? "No small thumb", book.thumbnail ?? "no thumbnail")
			if let thumb = book.smallThumb {
				coverImage.downloadImage(thumb)
			} else if let thumb = book.thumbnail {
				coverImage.downloadImage(thumb)
			}
		}
	}

	func loadImageFromURL(_ urlString:String)
	{
		let url = URL(string: urlString)!
		let req = URLRequest(url:url)
		print("Loading image..")
		GBooksAuthClient.shared.authorizeAndDataTask(req, EmptyHandler) { (data, _, error) in
			if let error = error {
				App.handleError(EmptyHandler, "Error loading image: \(error)")
				return
			}

			guard let data = data else {
				App.handleError(EmptyHandler, "Error loading image: no data")
				return
			}

			DispatchQueue.main.async {
				print("Got image, decoding")
				if let img = UIImage(data: data) {
					print("Set!")
					self.coverImage.image = img
				}
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
}

class BookDetailVC:UIViewController
{

}

class BookReviewVC:UIViewController
{

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
