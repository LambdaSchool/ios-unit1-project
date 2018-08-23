//
//  BookModel.swift
//  BookBuyer
//
//  Created by William Bundy on 8/22/18.
//  Copyright © 2018 William Bundy. All rights reserved.
//

import Foundation

struct BookStub: Equatable, Hashable
{
	var title:String
	var authors:[String]
	var review:String
	var tags:[String]
	var smallThumb:String?
	var thumbnail:String?
	var details:String?
	var googleIdentifier:String

	static func ==(l:BookStub, r:BookStub) -> Bool
	{
		return l.googleIdentifier == r.googleIdentifier
	}

	var hashValue: Int {
		return googleIdentifier.hashValue
	}
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
	var volumeCount:Int?

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
		var imageLinks:GImageLinks?
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

	func toStub() -> BookStub
	{
		return BookStub(
			title: self.volumeInfo.title,
			authors: self.volumeInfo.authors ?? [],
			review: "",
			tags: self.categories ?? [],
			smallThumb: self.volumeInfo.imageLinks?.smallThumbnail,
			thumbnail: self.volumeInfo.imageLinks?.thumbnail,
			details: self.volumeInfo.description,
			googleIdentifier: self.id)

	}
}

class BookController
{
	// TODO(will): store bookshelves "reversed":
	// eg: books know what bookshelves they're on, and build
	// the bookshelves from them, rather than the other way around
	var shelves:[BookshelfStub] = []
	var bookSet:Set<BookStub> {
		get {
			var all:Set<BookStub> = []
			for shelf in shelves {
				for book in shelf.volumes {
					all.insert(book)
				}
			}
			return all
		}
	}

	var bookArray:[BookStub] {
		get {
			return Array(bookSet)
		}
	}


	func reloadBook(_ stub:BookStub) -> BookStub?
	{
		for i in 0..<shelves.count {
			if let index = shelves[i].volumes.index(of: stub) {
				return shelves[i].volumes[index]
			}
		}
		return nil
	}

	func updateReview(_ stub:BookStub, _ review:String)
	{
		for i in 0..<shelves.count {
			if let index = shelves[i].volumes.index(of: stub) {
				shelves[i].volumes[index].review = review
				// TODO(will) update coredata
			}
		}
	}

	func fetchVolumesInBookshelf(_ shelf:GBookshelf,
								   _ shelves:GBookshelf.GBookshelfCollection,
								   _ completion: @escaping CompletionHandler = EmptyHandler)
	{
		let req = buildRequest(["mylibrary", "bookshelves", String(shelf.id), "volumes"], "GET")
		GBooksAuthClient.shared.authorizeAndDataTask(req, completion) { data, _, error in
			if let error = error {
				NSLog("Error getting bookshelf volumes: \(error)")
				return
			}
			guard let data = data else { return }
			do {
				let books = try JSONDecoder().decode(GBook.GBookCollection.self, from:data)
				var stub = BookshelfStub(id: shelf.id, title: shelf.title, created: Date(), volumes: [])
				for book in (books.items ?? []) {
					stub.volumes.append(book.toStub())
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

		GBooksAuthClient.shared.authorizeAndDataTask(request, completion) { (data, _, error) in
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
