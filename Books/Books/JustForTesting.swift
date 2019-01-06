
import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    var book: BookModel?
   // var bookshelf: Bookshelf?
    var table = BooksTableViewController()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.shared.addNewBook()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    func update() {
        
        guard let book = Model.shared.book else {return}
        DispatchQueue.main.async {
           
            self.titleLabel.text = book.items[0].volumeInfo.title
        
            }
    }
    
    func searchBarSearchButtonClicked(_  searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty
            else {return}
        searchBar.text = ""
        
        Model.shared.performSearch(with: searchTerm) { (error) in
            //Model.shared.clearBooks()
            if let error = error {
                NSLog("Error fetching data: \(error)")
                return
            }
            DispatchQueue.main.async {
                
                self.table.tableView.reloadData()
                self.update()
                
                
            }
        }
    }
    
    
    @IBAction func authorize(_ sender: Any) {
        
       
        update()
        Model.shared.clearBooks()
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            if let error = error {
                NSLog("Authorization failed: \(error)")
                return
            }
        }
    }
    
    @IBAction func fetchData(_ sender: Any) {
        Model.shared.addNewBook()
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
    }
    
}

