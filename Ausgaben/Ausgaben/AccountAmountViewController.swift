//
//  AccountAmountViewController.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 27.02.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Foundation

class AccountAmountViewController : UIViewController {
    
    private var picker : Picker?
    var amount : Double?
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton.enabled = false
        self.picker = Picker(4, value: self.amount) { self.handleUpdate($0) }
        pickerView.dataSource = self.picker
        pickerView.delegate = self.picker
    }
    
    func handleUpdate(value : Double) {
        self.amount = value
        self.doneButton.enabled = value > 0.0
    }
}