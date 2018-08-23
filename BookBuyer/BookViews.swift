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
			//coverImage = UIImage
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
