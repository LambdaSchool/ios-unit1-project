//
//  App.swift
//  BookBuyer
//
//  Created by William Bundy on 8/21/18.
//  Copyright © 2018 William Bundy. All rights reserved.
//

import Foundation

enum App
{
	static var transactionController = TransactionController()
	static var bookController = BookController()
	static var spendingStats = SpendingStats()

	static func handleError(_ completion:CompletionHandler, _ errorString: String?)
	{
		if let error = errorString {
			NSLog(error)
			completion(error)
		} else {
			completion(nil)
		}
	}
}

typealias CompletionHandler = (String?) -> Void
let EmptyHandler:CompletionHandler = { _ in }

func buildRequest(_ ids:[String], _ httpMethod:String, _ data:Data?=nil, queries:[String:String] = [:]) -> URLRequest
{
	var url = URL(string: "https://www.googleapis.com/books/v1/")!
	for id in ids {
		url.appendPathComponent(id)
	}
	var comp = URLComponents(url: url, resolvingAgainstBaseURL: false)!
	var qis:[URLQueryItem] = []
	for (k,v) in queries {
		qis.append(URLQueryItem(name:k, value:v))
	}
	comp.queryItems = qis
	url = comp.url!

	var req = URLRequest(url: url)
	req.httpMethod = httpMethod
	req.httpBody = data
	return req
}
