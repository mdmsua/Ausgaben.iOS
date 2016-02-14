//
//  Account.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 23.01.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Foundation

struct Account {
    
    let id: String
    
    let name: String
    
    let balance: Double
    
    init?(_ dictionary : [NSObject: AnyObject]) {
        guard let id = dictionary["id"] as? String else {
            return nil
        }
        guard let name = dictionary["name"] as? String else {
            return nil
        }
        guard let balance = dictionary["balance"] as? Double else {
            return nil
        }
        self.id = id
        self.name = name
        self.balance = balance
    }
}