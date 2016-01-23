//
//  ClientController.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 23.01.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

class ClientController : UIViewController {
    
    lazy var client: MSClient = {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).client!
    }()
    
}