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
	var author:String
	var review:String
	var tags:[String]
}

struct BookshelfStub
{
	var title:String
	var created:Date
	var volumeCount:Int
	var volumesLastUpdated:Date

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
	struct GVolumeInfo:Codable
	{
		var title:String
		var publisher:String
		var description:String
	}

	struct GImageLinks
	{
		var smallThumbnail:String
		var thumbnail:String
	}

	var kind:String
	var id:String
	var selfLink:String
	var volumeInfo:GVolumeInfo
	var imageLinks:GImageLinks
	var publishedDate:Int?

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
	var data:[BookStub] = []

}
