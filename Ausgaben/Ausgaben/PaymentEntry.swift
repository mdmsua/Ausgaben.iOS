//
//  PaymentEntry.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 20.02.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Foundation

struct PaymentEntry {
    
    let id : String
    
    let accountId : String

    let categoryId : UInt
    
    let amount : Double
    
    let description : String?
    
    let timestamp : NSDate
    
    let category : Category
    
    var formattedAmount : String {
        get {
            let formatter = NSNumberFormatter()
            formatter.currencyCode = "EUR"
            formatter.numberStyle = .CurrencyStyle
            return formatter.stringFromNumber(self.amount)!
        }
    }
    
    var time : String {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .MediumStyle
        return formatter.stringFromDate(self.timestamp)
    }
    
    var date : String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        return formatter.stringFromDate(self.timestamp)
    }

    init?(_ dictionary : [NSObject: AnyObject]) {
        guard let id = dictionary["id"] as? String else {
            return nil
        }
        guard let accountId = dictionary["accountId"] as? String else {
            return nil
        }
        guard let categoryId = dictionary["categoryId"] as? UInt else {
            return nil
        }
        guard let amount = dictionary["amount"] as? Double else {
            return nil
        }
        guard let timestamp = dictionary["timestamp"] as? NSDate else {
            return nil
        }
        guard let category = Category(dictionary["category"] as! [NSObject: AnyObject]) else {
            return nil
        }
        self.id = id
        self.accountId = accountId
        self.categoryId = categoryId
        self.amount = amount
        self.description = dictionary["description"] as? String
        self.timestamp = timestamp
        self.category = category
    }
}