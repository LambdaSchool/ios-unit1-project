//
//  TransactionsModel.swift
//  BookBuyer
//
//  Created by William Bundy on 8/21/18.
//  Copyright © 2018 William Bundy. All rights reserved.
//

import Foundation

enum TransactionStatus: String, Codable
{
	case completed
	case requested
	case sent
	case pending
}

enum TransactionCategory: String, Codable
{
	case misc
	case books
	case groceries

	static let all:[TransactionCategory] = [.misc, .books, .groceries]
}

struct TransactionStub: Equatable, Comparable, Codable
{
	var price:Int // in cents
	var category:TransactionCategory
	var status:TransactionStatus
	var identifier:UUID
	var timestamp:Date

	var itemName:String?
	var description:String?

	init(_ price:Int,
		 category:TransactionCategory = .misc,
		 status:TransactionStatus = .completed,
		 identifier:UUID = UUID(),
		 timestamp:Date = Date())
	{
		self.price = price
		self.status = status
		self.category = category
		self.identifier = identifier
		self.timestamp = timestamp
	}


	static func ==(l:TransactionStub, r:TransactionStub) -> Bool
	{
		return l.identifier == r.identifier
	}

	static func <(l:TransactionStub, r:TransactionStub) -> Bool
	{
		return l.timestamp < r.timestamp
	}

}

class TransactionController
{
	var data:[TransactionStub] = []

	func add(_ stub:TransactionStub)
	{
		data.append(stub)
	}

	// update stub in array if it has same identifier
	func update(_ stub:TransactionStub)
	{
		guard let index = data.index(of:stub) else {return}
		data[index] = stub
	}

	func remove(_ stub:TransactionStub)
	{
		guard let index = data.index(of:stub) else {return}
		data.remove(at: index)
	}

	func sumTransactions() -> (total:Int, books:Int, withoutBooks:Int)
	{
		var sum = 0
		var books = 0
		var withoutBooks = 0
		for tr in data {
			sum += tr.price
			if tr.category == .books {
				books += tr.price
			} else {
				withoutBooks += tr.price
			}
		}
		return (sum, books, withoutBooks)
	}

}

