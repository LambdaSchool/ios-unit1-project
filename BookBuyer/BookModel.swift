//
//  BookModel.swift
//  BookBuyer
//
//  Created by William Bundy on 8/22/18.
//  Copyright © 2018 William Bundy. All rights reserved.
//

import Foundation

struct BookStub
{
	var title:String
	var authors:[String]
	var review:String
	var tags:[String]
	var smallThumb:String?
	var thumbnail:String?
}

struct BookshelfStub
{
	var id:Int
	var title:String
	var created:Date
	var volumes:[BookStub]
}


struct GBookshelf: Codable, Equatable, Comparable
{
	struct GBookshelfCollection:Codable
	{
		let items:[GBookshelf]
	}

	var kind:String
	var id:Int
	var selfLink:String
	var title:String
	//var updated:Date?
//	var created:Date?
	var volumeCount:Int?
	//var volumesLastUpdated:Date?

	static func ==(l:GBookshelf, r:GBookshelf) -> Bool
	{
		return l.id == r.id
	}

	static func <(l:GBookshelf, r:GBookshelf) -> Bool
	{
		return l.title < r.title
	}
}

struct GBook: Codable
{
	struct GBookCollection:Codable
	{
		let items:[GBook]?
		let totalItems:Int?
	}

	struct GVolumeInfo:Codable
	{
		var title:String
		var publisher:String?
		var description:String?
		var authors:[String]?
	}

	struct GImageLinks: Codable
	{
		var smallThumbnail:String
		var thumbnail:String
	}

	var kind:String
	var id:String
	var selfLink:String
	var volumeInfo:GVolumeInfo
	var imageLinks:GImageLinks?
	var publishedDate:Int?
	var categories:[String]?

	static func ==(l:GBook, r:GBook) -> Bool
	{
		return l.id == r.id
	}

	static func <(l:GBook, r:GBook) -> Bool
	{
		return l.volumeInfo.title < r.volumeInfo.title
	}
}

class BookController
{
	var shelves:[BookshelfStub] = []

	func authorizeAndDataTask(_ req:URLRequest, _ completion:@escaping CompletionHandler, _ action: @escaping (Data?, URLResponse?, Error?) -> Void)
	{
		GBooksAuthClient.shared.addAuthorization(to: req) { (request, error) in
			if let error = error {
				App.handleError(completion, "GAuth: \(error)")
				return
			}
			guard let request = request else {
				App.handleError(completion, "GAuth: no request")
				return
			}
			URLSession.shared.dataTask(with: request, completionHandler: action).resume()
		}
	}

	func fetchVolumesInBookshelf(_ shelf:GBookshelf,
								   _ shelves:GBookshelf.GBookshelfCollection,
								   _ completion: @escaping CompletionHandler = EmptyHandler)
	{
		let req = buildRequest(["mylibrary", "bookshelves", String(shelf.id), "volumes"], "GET")
		authorizeAndDataTask(req, completion) { data, _, error in
			if let error = error {
				NSLog("Error getting bookshelf volumes: \(error)")
				return
			}
			guard let data = data else { return }
			do {
				let books = try JSONDecoder().decode(GBook.GBookCollection.self, from:data)
				var stub = BookshelfStub(id: shelf.id, title: shelf.title, created: Date(), volumes: [])
				for book in (books.items ?? []) {
					stub.volumes.append(BookStub(
						title: book.volumeInfo.title,
						authors: book.volumeInfo.authors ?? [],
						review: "",
						tags: book.categories ?? [],
						smallThumb: book.imageLinks?.smallThumbnail,
						thumbnail: book.imageLinks?.thumbnail))
				}
				self.shelves.append(stub)
				if self.shelves.count == shelves.items.count {
					self.shelves.sort { $0.volumes.count > $1.volumes.count }
					completion(nil)
				}
			} catch {
				completion("Couldn't decode bookshelf volume json \(error)")
				if let json = String(data:data, encoding:.utf8) {
					print(json)
				}
				return
			}
		}
	}
	func fetchShelvesAndContents(_ completion:@escaping CompletionHandler = EmptyHandler)
	{
		let url = URL(string: "https://www.googleapis.com/books/v1/mylibrary/bookshelves/")!
		let request = URLRequest(url: url)

		authorizeAndDataTask(request, completion) { (data, _, error) in
			if let error = error {
				App.handleError(completion, "Error fetching bookshelves: \(error)")
				return
			}
			guard let data = data else {
				App.handleError(completion, "Fetching: bookshelf data was nil")
				return
			}

			do {
				let shelves = try JSONDecoder().decode(GBookshelf.GBookshelfCollection.self, from:data)
				self.shelves.removeAll(keepingCapacity: true)
				for shelf in shelves.items {
					self.fetchVolumesInBookshelf(shelf, shelves, completion)
				}
			} catch {
				App.handleError(completion, "Fetching: could not decode bookshelf json: \(error)")
				if let json = String(data:data, encoding:.utf8) {
					print(json)
				}
				return
			}
		}
	}
}
