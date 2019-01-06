import Foundation

struct Bookshelves: Codable {
    var recordIdentifier: String = ""
    var bookshelves: [Bookshelf]
}
struct Bookshelf: Codable {
    var name: String
    var books: [Book]
}
struct Volumes: Codable {
    let items: [VolumeInfo]
}
struct VolumeInfo: Codable {
    let volumeInfo: Book
}
struct Book: Codable {
    let title: String
    let imageLinks: Image?
}
struct Image: Codable {
    let smallThumbnail: String
    let thumbnail: String
}

