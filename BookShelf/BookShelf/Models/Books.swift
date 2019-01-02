import Foundation

struct Books: Codable {
    let items: [Book]
}
struct Book: Codable {
    let title: String
    let imageLinks: Image
}
struct Image: Codable {
    let smallThumbnail: String
}

