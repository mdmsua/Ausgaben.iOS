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
    
    private var busy = false
    
    @IBOutlet var accountTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl!.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.handleRefresh(self.refreshControl!)
    }
    
    override func viewDidAppear(animated: Bool) {
        if !busy {
            self.handleRefresh(self.refreshControl!)
        }
    }
    
    func handleRefresh(sender: UIRefreshControl) {
        sender.beginRefreshing()
        self.accounts.removeAll()
        self.busy = true
        client.tableWithName("Accounts").readWithQueryString("$orderby=name") { (result, error) -> Void in
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
                    }
                }
            }
            sender.endRefreshing()
            self.busy = false
            self.accountTableView.reloadData()
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