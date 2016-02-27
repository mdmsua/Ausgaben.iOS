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
    
    @IBOutlet var accountTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl!.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.accountTableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadAccounts({() -> () in});
    }
    
    func loadAccounts(callback: () -> ()) {
        self.accounts.removeAll()
        client.tableWithName("Accounts").readWithCompletion { (result, error) -> Void in
            if let error = error {
                self.alert(error)
            } else {
                if let result = result {
                    if let items = result.items {
                        for item in items {
                            if let account = Account(item) {
                                self.accounts.append(account)
                            }
                        }
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
        return accounts.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.accounts.count == 0 {
            return UITableViewCell()
        }
        let cell:UITableViewCell = self.accountTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let account = accounts[indexPath.row]
        cell.textLabel?.text = account.name
        cell.detailTextLabel?.text = account.formattedBalance
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        self.index = indexPath.row
        self.performSegueWithIdentifier("Payments", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let paymentsViewController = segue.destinationViewController as? PaymentsViewController {
            paymentsViewController.account = self.accounts[self.index]
        }
    }
}