//
//  PaymentsViewController.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 14.02.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Foundation

class PaymentsViewController : UITableViewController {
    
    var account: Account?
    
    var payments = [String: [PaymentEntry]]()
    
    var sections : [String] {
        return self.payments.map { $0.0 }
    }
    
    private var busy = false;
    
    @IBOutlet weak var paymentsTableView: UITableView!
    
    override func viewDidLoad() {
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.title = self.account?.name
        self.handleRefresh(self.refreshControl!)
    }
    
    override func viewDidAppear(animated: Bool) {
        if !busy {
            self.handleRefresh(self.refreshControl!)
        }
    }
    
    func handleRefresh(sender: UIRefreshControl) {
        if let account = self.account {
            self.busy = true
            self.payments.removeAll()
            sender.beginRefreshing()
            let query = "$filter=(accountId%20eq%20guid'\(account.id)')&$expand=category"
            self.client.tableWithName("Payments").readWithQueryString(query) { (result, error) -> Void in
                if let error = error {
                    self.alert(error)
                } else {
                    if let result = result {
                        if let items = result.items {
                            var payments = [PaymentEntry]()
                            for item in items {
                                if let payment = PaymentEntry(item) {
                                    payments.append(payment)
                                }
                            }
                            self.payments = self.groupByDate(payments)
                        }
                    }
                    self.paymentsTableView.reloadData()

                }
                self.busy = false
                sender.endRefreshing()
            }
        }
    }
    
    func groupByDate(array: [PaymentEntry]) -> [String: [PaymentEntry]] {
        var dictionary = [String: [PaymentEntry]]()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        for element in array {
            let key = formatter.stringFromDate(element.timestamp)
            var array: [PaymentEntry]? = dictionary[key]
    
            if (array == nil) {
                array = [PaymentEntry]()
            }
    
            array!.append(element)
            dictionary[key] = array!
        }
    
        return dictionary
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "payment" {
            if let id = self.account?.id {
                (segue.destinationViewController as! PaymentViewController).payment = Payment(id)
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let section = self.sections[indexPath.section]
        let payments = self.payments[section]
        let payment = payments![indexPath.row]
        cell.textLabel?.text = payment.category.name
        cell.detailTextLabel!.text = payment.formattedAmount
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = self.sections[section]
        return self.payments[key]!.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
//    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        let group = self.sections[section]
//        let payments = self.payments[group]
//        let total = payments?.reduce(0.0, combine: { $0! + $1.amount })
//        let formatter = NSNumberFormatter()
//        formatter.currencyCode = "EUR"
//        formatter.numberStyle = .CurrencyStyle
//        return formatter.stringFromNumber(total!)
//    }
}