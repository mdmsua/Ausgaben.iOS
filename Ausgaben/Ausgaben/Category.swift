//
//  Category.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 14.02.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

struct Category {
    
    let id: UInt
    
    let name: String
    
    let type: Bool
    
    let categories: [Category]?
    
    init?(_ dictionary : [NSObject: AnyObject]) {
        guard let id = dictionary["id"] as? UInt else {
            return nil
        }
        guard let name = dictionary["name"] as? String else {
            return nil
        }
        guard let type = dictionary["type"] as? Bool else {
            return nil
        }
        let categories = dictionary["categories"] as? [[NSObject: AnyObject]]
        self.id = id
        self.name = name
        self.type = type
        self.categories = categories?.flatMap { Category($0) }
    }
}
