//
//  AccountViewController.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 24.01.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Foundation

class AccountViewController : UITableViewController {
    
    var balance: Double? = 0.0
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBAction func nameEditingChanged(sender: UITextField) {
        updateDoneButton(sender.text)
    }
    
    @IBAction func unwindFromAmount(sender: UIStoryboardSegue) {
        if let amountViewController = sender.sourceViewController as? AccountAmountViewController {
            self.balance = amountViewController.amount
            let formatter = NSNumberFormatter()
            formatter.currencyCode = "EUR"
            formatter.numberStyle = .CurrencyStyle
            balanceLabel.text = formatter.stringFromNumber(self.balance!)
            updateDoneButton(self.nameTextField.text)
        }
    }
    
    @IBAction func doneButtonClicked(sender: UIButton) {
        let account : [NSObject: AnyObject] = ["name": nameTextField.text!, "balance": self.balance!]
        client.tableWithName("Accounts").insert(account) { (data, error) -> () in
            if let error = error {
                self.alert(error)
            } else {
                self.navigationController?.popViewControllerAnimated(true)
            }

        }
    }
    
    override func viewDidLoad() {
        self.doneButton.enabled = false
    }
    
    func updateDoneButton(name: String!) {
        self.doneButton.enabled = name.characters.count > 0 && self.balance != 0.0
    }
    
}