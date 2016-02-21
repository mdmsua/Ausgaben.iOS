//
//  AccountsViewController.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 23.01.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Foundation

class AccountsViewController : UITableViewController {
    
    var accounts = [Account]()
    
    var index: Int = -1
    
    var state = ViewState.Busy
    
    @IBOutlet var accountTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    override func viewDidAppear(animated: Bool) {
        self.state = .Busy
        self.accountTableView.reloadData()
        loadAccounts({() -> () in});
    }
    
    func loadAccounts(callback: () -> ()) {
        self.accounts.removeAll()
        client.tableWithName("Accounts").readWithCompletion { (result, error) -> Void in
            if let error = error {
                self.state = .Standby
                self.alert(error)
            } else {
                if let result = result {
                    if let items = result.items {
                        for item in items {
                            if let account = Account(item) {
                                self.accounts.append(account)
                            }
                        }
                        self.state = .Ready
                        self.accounts.sortInPlace() { $0.name < $1.name }
                    }
                }
            }
            self.accountTableView.reloadData()
            callback()
        }
    }
    
    @IBAction func logoutButtonClicked(sender: AnyObject) {
        client.logoutWithCompletion { (error) -> Void in
            if let error = error {
                self.alert(error)
            } else {
                self.performSegueWithIdentifier("App", sender: self)
            }
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        loadAccounts { () -> () in
            refreshControl.endRefreshing()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.state == .Ready ? accounts.count : 1;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch self.state {
        case .Busy:
            return self.accountTableView.dequeueReusableCellWithIdentifier("default")! as UITableViewCell
        case .Ready:
            let cell:UITableViewCell = self.accountTableView.dequeueReusableCellWithIdentifier("account")! as UITableViewCell
            let account = accounts[indexPath.row]
            cell.textLabel?.text = account.name
            cell.detailTextLabel?.text = account.formattedBalance
            cell.detailTextLabel?.textColor = account.balance > 0 ? UIColor.greenColor() : account.balance == 0 ? UIColor.grayColor() : UIColor.redColor()
            return cell
        default:
            return self.accountTableView.dequeueReusableCellWithIdentifier("empty")! as UITableViewCell
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        self.index = indexPath.row
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as! PaymentsViewController).account = self.accounts[self.index]
    }
}