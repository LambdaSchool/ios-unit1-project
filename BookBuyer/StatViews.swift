//
//  StatViews.swift
//  BookBuyer
//
//  Created by William Bundy on 8/21/18.
//  Copyright © 2018 William Bundy. All rights reserved.
//

import Foundation
import UIKit

class StatsVC:UIViewController
{
	@IBOutlet weak var amountRemainingLabel: UILabel!
	@IBOutlet weak var bookAmountLabel: UILabel!
	@IBOutlet weak var otherAmountLabel: UILabel!

	override func viewWillAppear(_ animated: Bool)
	{
		let stats = App.spendingStats
		let spending = App.transactionController.sumTransactions()
		let rem = stats.weeklyIncome - spending.total
		amountRemainingLabel.setMoney(rem, "You have %@ left")
		bookAmountLabel.setMoney(spending.books, "You've spent %@ on books")
		otherAmountLabel.setMoney(spending.withoutBooks, "You've spent %@ on other things")
	}
}

extension UILabel
{
	func setMoney(_ v:Int?, _ fmt:String="%@")
	{
		guard let v = v else {return}

		let f = NumberFormatter()
		f.numberStyle = .currency
		if let m = f.string(from: NSNumber(value: Double(v) / 100.0)) {
			self.text = String(format: fmt, m)
		}
	}
}
extension UITextField
{

	func setMoney(_ v:Int?)
	{
		guard let v = v else {return}

		let f = NumberFormatter()
		f.numberStyle = .currency
		if let m = f.string(from: NSNumber(value: Double(v) / 100.0)) {
			self.text = m
		}
	}

	func getMoneyAsInt() -> Int?
	{
		let text = self.text ?? ""
		let numbers = text.filter { "0123456789".contains($0) }
		return Int(numbers)
	}
}
class SettingsVC:UIViewController
{
	@IBOutlet weak var booksSlider: UISlider!
	@IBOutlet weak var groceriesSlider: UISlider!
	@IBOutlet weak var miscSlider: UISlider!
	
	@IBOutlet weak var allowanceField: UITextField!
	@IBAction func moneyValueChanged(_ sender: Any)
	{
		allowanceField.setMoney(allowanceField.getMoneyAsInt())
	}
	@IBAction func updateAllowance(_ sender: Any)
	{
		guard let number = allowanceField.getMoneyAsInt() else { return }
		App.spendingStats.weeklyIncome = number
		allowanceField.resignFirstResponder()
	}

	override func viewWillAppear(_ animated: Bool)
	{
		let number = App.spendingStats.weeklyIncome
		allowanceField.setMoney(number)
	}


}
