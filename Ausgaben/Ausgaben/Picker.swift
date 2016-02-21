//
//  Picker.swift
//  Ausgaben
//
//  Created by Dmytro Morozov on 20.02.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

public class Picker : NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    init(_ count: Int, value: Double? = 0.0, updated: (Double -> Void)? = nil) {
        self.count = count
        self.segments = [Int](count: count, repeatedValue: 0)
        self.updated = updated
    }
    
    private let count : Int
    private let updated: (Double -> Void)?
    private var last : Int {
        get {
            return self.count - 1
        }
    }
    private var segments: [Int]
    private var decimals = [0, 0]
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return self.count + 3
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == self.count ? 1 : 10
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == self.count ? "," : String(row)
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0...self.count:
            self.segments[component] = row
        case self.count+1...self.count+3:
            self.decimals[self.count+2-component] = row
        default:
            break
        }
        let m = self.segments.enumerate().reduce(0, combine: { $0 + Double($1.1) * pow(10.0, Double(self.last-$1.0)) })
        let e = self.decimals.enumerate().reduce(0, combine: { $0 + Double($1.1) * pow(10.0, Double(-2+$1.0)) })
        let temp = m + e
        if self.updated != nil {
            self.updated!(temp)
        }
    }

}
