
import UIKit

class BookshelfTableViewController: UITableViewController {

    var bookshelf: BookshelfJson? {
        didSet {
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // tableView.reloadData()
     
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 11
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookshelf", for: indexPath) as! BookshelfTableViewCell

        // Configure the cell...
        guard let bookshelf = ModelBookshelf.shared.bookshelf else {return cell}
        cell.bookshelfTitle.text = bookshelf.items[indexPath.row].title
        cell.bookshelfId.text = "ID: \(bookshelf.items[indexPath.row].id)"
        if let volumeCount = bookshelf.items[indexPath.row].volumeCount {
            cell.bookshelfVolumeCount.text = "Books in shelf: \(String(describing: volumeCount))" }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search" {
            guard let indexPath = tableView.indexPathForSelectedRow
                else {return}
            let destination = segue.destination as! BookshelfDetailViewController
            let bookshelf = ModelBookshelf.shared.bookshelf?.items[indexPath.row]
            destination.bookshelf = bookshelf
        }
    }
}
