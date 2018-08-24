//
//  TransactionViews.swift
//  BookBuyer
//
//  Created by William Bundy on 8/21/18.
//  Copyright © 2018 William Bundy. All rights reserved.
//

import Foundation
import UIKit



class TransactionCell:UITableViewCell
{
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var itemLabel: UILabel!

	var transaction:TransactionStub! {
		didSet {
			let p = transaction.price
			/*
			var sign = false
			if p < 0 {
				sign = true
			}
			*/
			priceLabel.setMoney(p)
			itemLabel.text = transaction.itemName ?? transaction.category.rawValue
		}
	}
}

class TransactionTVC:UITableViewController
{
	var controller:TransactionController!

	@IBOutlet weak var costField: UITextField!
	@IBOutlet weak var categorySelector: UISegmentedControl!
	@IBOutlet weak var addButton: UIButton!

	@IBAction func costChanged(_ sender: Any)
	{
		costField.setMoney(costField.getMoneyAsInt())
	}

	@IBAction func addTransaction(_ sender: Any)
	{
		guard let cost = costField.getMoneyAsInt() else {return}
		costField.text = nil
		let category = TransactionCategory.all[categorySelector.selectedSegmentIndex]
		let t = TransactionStub(cost, category:category)
		controller.add(t)
		tableView.reloadSections([0], with: .fade)
		costField.resignFirstResponder()
	}

	override func viewDidLoad()
	{
		super.viewDidLoad()
		controller = App.transactionController
	}

	override func viewWillAppear(_ animated: Bool)
	{
		tableView.reloadData()
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let defaultCell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
		guard let cell = defaultCell as? TransactionCell else { return defaultCell }
		cell.transaction = controller.data[indexPath.row]
		return cell
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return controller.data.count
	}
}
