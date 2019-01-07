
import Foundation

struct BookModel: Codable {
    let totalItems: Int?
    var items: [Book]
}
struct Book: Codable {
    let volumeInfo: VolumeInfo
    
        struct VolumeInfo: Codable {
            let title: String?
            let subtitle: String?
            let authors: [String]?
            let imageLinks: ImageLink?
            let description: String?
            let infoLink: String?
            let pageCount: Int?
                
            struct ImageLink: Codable {
                let smallThumbnail: String?
                let thumbnail: String?
                }
            }
}

