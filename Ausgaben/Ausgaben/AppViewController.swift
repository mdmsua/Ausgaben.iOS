//
//  ViewController.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 11.01.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (client.currentUser != nil) {
            self.performSegueWithIdentifier("Main", sender: self)
        }
    }
    
    func loginWithProvider(provider: String) {
        client.loginWithProvider(provider, controller: self, animated: true) {
            (user, error) in
            if let error = error {
                self.alert(error)
            } else {
                self.performSegueWithIdentifier("Main", sender: self)
            }
        }
    }

    @IBAction func facebookButtonClicked(sender: UIButton) {
        loginWithProvider("facebook")
    }
    
    @IBAction func twitterButtonClicked(sender: UIButton) {
        loginWithProvider("twitter")
    }

    @IBAction func googleButtonClicked(sender: UIButton) {
        loginWithProvider("google")
    }
}

