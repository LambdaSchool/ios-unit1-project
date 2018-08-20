//
//  ViewController.swift
//  Book Library
//
//  Created by Jeremy Taylor on 8/20/18.
//  Copyright © 2018 Bytes-Random L.L.C. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func authorize(_ sender: Any) {
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            if let error = error {
                NSLog("Authorization failed: \(error)")
                return
            }
        }
    }
    
    @IBAction func fetchData(_ sender: Any) {
        
        let url = URL(string: "https://www.googleapis.com/books/v1/mylibrary/bookshelves")!
        let request = URLRequest(url: url)
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            
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

