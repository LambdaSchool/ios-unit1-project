//
//  BorrowButtonDelegate.swift
//  Books
//
//  Created by Farhan on 9/24/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation

protocol BorrowButtonDelegate: class {
    func borrowButtonWasPressed(_ sender: SearchTableViewCell)
}
