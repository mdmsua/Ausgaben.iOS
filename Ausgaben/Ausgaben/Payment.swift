//
//  Payment.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 20.02.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

class Payment {
    
    let accountId : String
    
    var amount : Double = 0.0
    
    var categoryId : UInt = 0
    
    var description : String? = nil
    
    var timestamp = NSDate()
    
    var valid : Bool {
        get {
            return self.amount != 0.0 && self.categoryId > 0
        }
    }
    
    init(_ account : String) {
        self.accountId = account
    }
    
    func serialize() -> [NSObject: AnyObject] {
        return ["accountId": self.accountId, "categoryId": self.categoryId, "amount": self.amount, "description": self.description ?? "", "timestamp": self.timestamp]
    }
}
