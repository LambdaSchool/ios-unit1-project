//
//import UIKit
//import SafariServices
//
//class ViewController: UIViewController {
//    
//    let destination: NSURL = NSURL(string: "http://desappstre.com")!
//    
//   // let safari: SFSafariViewController = SFSafariViewController(URL: destination)
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
////    var book: BookModel?
////   // var bookshelf: Bookshelf?
////    var table = BooksTableViewController()
////
////    @IBOutlet weak var searchBookshelf: UISearchBar!
////    @IBOutlet weak var titleLabel: UILabel!
////
////    @IBOutlet weak var bookshelfLabel: UILabel!
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////    }
////
////    override func viewWillAppear(_ animated: Bool) {
////        super.viewWillAppear(animated)
////                updateView()
////        guard let bookshelf = ModelBookshelf.shared.bookshelf else {return}
////        bookshelfLabel.text = bookshelf.items[1].title
////
////    }
////
////    func updateView() {
////
////
////        guard let book = Model.shared.book else {return}
////        titleLabel.text = book.items[0].volumeInfo.title
////        }
//    
//    
////    func searchBarSearchButtonClicked(_  searchBookshelf: UISearchBar) {
////        searchBookshelf.resignFirstResponder()
////        guard let searchText = searchBookshelf.text, !searchText.isEmpty
////            else {return}
////        searchBookshelf.text = ""
////
//////        ModelBookshelf.shared.bookPerformSearch(with: searchText) { (error) in
//////            //Model.shared.clearBooks()
//////            if let error = error {
//////                NSLog("Error fetching data: \(error)")
//////                return
//////            }
////            DispatchQueue.main.async {
////
////                self.table.tableView.reloadData()
////                self.update()
////
////
////            }
////        }
//    
//    
//    
//    @IBAction func authorize(_ sender: Any) {
//        
//       
//       // updateView()
//        Model.shared.clearBooks()
//        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
//            if let error = error {
//                NSLog("Authorization failed: \(error)")
//                return
//            }
//        }
//    }
//    
//    @IBAction func fetchData(_ sender: Any) {
//        Model.shared.addNewBook()
//        let url = URL(string: "https://www.googleapis.com/books/v1/mylibrary/bookshelves")!
//        let request = URLRequest(url: url)
//
//        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
//
//            if let error = error {
//                NSLog("Error adding authorization to request: \(error)")
//                return
//            }
//            guard let request = request else { return }
//
//            URLSession.shared.dataTask(with: request) { (data, _, error) in
//                if let error = error {
//                    NSLog("Error getting bookshelves: \(error)")
//                    return
//                }
//                guard let data = data else { return }
//
//                if let json = String(data: data, encoding: .utf8) {
//                    print(json)
//                }
//                }.resume()
//        }
//    }
//    
//}
//
