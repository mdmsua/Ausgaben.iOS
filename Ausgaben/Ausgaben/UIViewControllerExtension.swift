//
//  ClientControllerExtension.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 23.01.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

extension UIViewController {
    
    var client: MSClient {
        get {
            return (UIApplication.sharedApplication().delegate as! AppDelegate).client!
        }
    }
    
    func alert(error: NSError, handler: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: handler))
        self.presentViewController(alertController, animated: true, completion: completion)
    }

}
