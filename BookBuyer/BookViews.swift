//
//  BookViews.swift
//  BookBuyer
//
//  Created by William Bundy on 8/21/18.
//  Copyright © 2018 William Bundy. All rights reserved.
//


import Foundation
import UIKit


class ShelfListVC:UITableViewController
{
	override func viewDidLoad()
	{
		GBooksAuthClient.shared.authorizeIfNeeded(presenter: self) { (error) in
			if let error = error {
				NSLog("Authorization failed: \(error)")
				return
			}
		}

		let url = URL(string: "https://www.googleapis.com/books/v1/mylibrary/bookshelves/7/volumes")!
		let request = URLRequest(url: url)

		GBooksAuthClient.shared.addAuthorization(to: request) { (request, error) in
			if let error = error {
				NSLog("Error adding authorization to request: \(error)")
				return
			}
			guard let request = request else { return }

			URLSession.shared.dataTask(with: request) { (data, _, error) in
				if let error = error {
					NSLog("Error getting bookshelves: \(error)")
					return
				}
				guard let data = data else { return }

				if let json = String(data: data, encoding: .utf8) {
					print(json)
				}
			}.resume()
		}
	}
}

class BookListVC:UICollectionViewController
{
	
}

class BookDetailVC:UIViewController
{

}
