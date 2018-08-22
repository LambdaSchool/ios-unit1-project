//
//  BookController.swift
//  Books
//
//  Created by Linh Bouniol on 8/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation

class BookController {

    // MARK: - CRUD
    
    func createBook(with searchResult: SearchResult, inBookshelf bookshelf: Bookshelf) {
        guard let book = Book(searchResult: searchResult) else { return }
        book.bookshelf = bookshelf
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error creating book: \(error)")
        }
    }

    func move(book: Book, to bookshelf: Bookshelf) {
        book.bookshelf = bookshelf

        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error moving book: \(error)")
        }
    }

    func toggleHasRead(for book: Book) {
        book.hasRead = !book.hasRead

        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error updating book: \(error)")
        }
    }
    
    func update(book: Book, with review: String) {
        book.review = review
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error updating book review: \(error)")
        }
    }

    func delete(book: Book) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(book)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error deleting book: \(error)")
        }
    }
    
    func createBookshelf(with name: String) {
        let _ = Bookshelf(name: name)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error creating bookshelf: \(error)")
        }
    }

    func rename(bookshelf: Bookshelf, with newName: String) {
        bookshelf.name = newName

        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error renaming bookshelf: \(error)")
        }
    }

    func delete(bookshelf: Bookshelf) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(bookshelf)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error deleting bookshelf: \(error)")
        }
    }
}
