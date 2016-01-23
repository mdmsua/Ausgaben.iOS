//
//  ViewController.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 11.01.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import UIKit

class AppViewController: ClientController {
    
    func loginWithProvider(provider: String) {
        client.loginWithProvider(provider, controller: self, animated: true, completion: {
            (user, error) -> () in
            if let error = error {
                let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.performSegueWithIdentifier("Main", sender: self)
            }
        })
    }

    @IBAction func facebookButtonClicked(sender: UIButton) {
        loginWithProvider("facebook")
    }
    
    @IBAction func twitterButtonClicked(sender: UIButton) {
        loginWithProvider("twitter")
    }

}

