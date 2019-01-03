import Foundation

struct Bookshelves {
    var bookshelves: [Bookshelf]
}
struct Bookshelf {
    let name: String
    var volumes: [Volumes]
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

