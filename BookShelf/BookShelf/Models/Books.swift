import Foundation

struct Volumes: Codable {
    let items: [VolumeInfo]
}
struct VolumeInfo: Codable {
    let volumeInfo: Book
}
struct Book: Codable {
    let title: String
//    let imageLinks: Image
}
struct Image: Codable {
    let smallThumbnail: String
}

