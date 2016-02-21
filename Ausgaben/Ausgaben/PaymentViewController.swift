//
//  PaymentViewController.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 14.02.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Foundation

class PaymentViewController : UITableViewController {
    
    var category : Category?
    var payment : Payment?
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBAction func doneButtonClicked(sender: UIBarButtonItem) {
        doneButton.enabled = false
        if let payment = self.payment {
            self.client.tableWithName("Payments").insert(payment.serialize()) { (data, error) -> Void in
                if let error = error {
                    self.alert(error)
                    self.doneButton.enabled = false
                } else {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
    
    @IBAction func typeChanged(sender: UISegmentedControl) {
        self.category = nil
        self.categoryLabel.text = nil
        self.payment?.categoryId = 0
        self.doneButton.enabled = (self.payment?.valid)!
    }
    
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    
    @IBAction func unwindWithSelectedCategory(segue:UIStoryboardSegue) {
        if let categoriesViewController = segue.sourceViewController as? CategoriesViewController,
            category = categoriesViewController.category {
                self.category = category
                self.categoryLabel.text = category.name
                self.payment?.categoryId = category.id
                self.doneButton.enabled = (self.payment?.valid)!
        }
    }
    
    @IBAction func unwindWithSelectedAmount(segue:UIStoryboardSegue) {
        if let amountViewController = segue.sourceViewController as? AmountViewController,
            amount = amountViewController.amount {
                self.payment?.amount = amount
                let formatter = NSNumberFormatter()
                formatter.currencyCode = "EUR"
                formatter.numberStyle = .CurrencyStyle
                self.amountLabel.text = formatter.stringFromNumber(amount)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "category" {
            let categoriesViewController = segue.destinationViewController as! CategoriesViewController
            categoriesViewController.type = self.typeSegmentedControl.selectedSegmentIndex == 1
            categoriesViewController.category = self.category
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.enabled = false
    }

}
