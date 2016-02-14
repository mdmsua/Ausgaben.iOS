//
//  AccountViewController.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 24.01.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Foundation

class AccountViewController : UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var balanceTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBAction func nameEditingChanged(sender: UITextField) {
        updateDoneButton(sender.text, balance: balanceTextField.text!)
    }
    
    @IBAction func balanceEditingChanged(sender: UITextField) {
        updateDoneButton(nameTextField.text!, balance: sender.text)
    }
    
    @IBAction func doneButtonClicked(sender: UIBarButtonItem) {
        let account : [NSObject: AnyObject] = ["name": nameTextField.text!, "balance": Double(balanceTextField.text!)!]
        client.tableWithName("Accounts").insert(account) { (data, error) -> () in
            if let error = error {
                print(error)
                let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.navigationController?.popViewControllerAnimated(true)
            }

        }
    }
    
    override func viewDidLoad() {
        doneButton.enabled = false
    }
    
    func updateDoneButton(name: String!, balance: String!) {
        doneButton.enabled = name.characters.count > 0 && Double(balance) != nil
    }
    
}