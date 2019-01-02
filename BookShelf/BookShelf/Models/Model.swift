import Foundation

class Model {
    static let shared = Model()
    private init() {}
    
    var books: Books?
}
