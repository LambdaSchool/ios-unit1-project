//
//  SelectShelfTableViewController.swift
//  Books
//
//  Created by Andrew Liao on 8/24/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit

class SelectShelfTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Book.sectionNameDictionary.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShelfCell", for: indexPath)
        cell.textLabel?.text = Book.sectionNameDictionary[indexPath.row]
        cell.detailTextLabel?.text = String(bookController?.bookRepresentationsDirectory[indexPath.row]?.count ?? 0)
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    var bookController: BookController?
}
