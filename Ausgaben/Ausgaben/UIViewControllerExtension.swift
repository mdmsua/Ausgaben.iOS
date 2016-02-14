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

}
