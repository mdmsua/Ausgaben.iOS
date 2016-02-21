//
//  CategoriesViewController.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 14.02.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Foundation

class CategoriesViewController : UITableViewController {
    
    var categories = [Category]()
    
    var category : Category?
    
    var type : Bool? = nil
    
    override func viewDidLoad() {
        client.invokeAPI("Categories", data: nil, HTTPMethod: "GET", parameters: nil, headers: nil) { (data, response, error) -> Void in
            do {
                let categories = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [[NSObject: AnyObject]]
                for item in categories {
                    if let category = Category(item) {
                        self.categories.append(category)
                    }
                }
                self.categories = self.categories.filter { $0.type == self.type }
                self.tableView.reloadData()
            } catch {
                
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categories = self.categories[section].categories {
            return categories.count
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("category")! as UITableViewCell
        var category : Category
        if let categories = self.categories[indexPath.section].categories {
            category = categories[indexPath.row]
        } else {
            category = self.categories[indexPath.section]
        }
        cell.textLabel?.text = category.name
        cell.accessoryType = self.category?.id == category.id ? .Checkmark : .None
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.categories[section].name
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.categories.count
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if let categories = self.categories[indexPath.section].categories {
            self.category = categories[indexPath.row]
        } else {
            self.category = self.categories[indexPath.section]
        }
        return indexPath
    }
    
}