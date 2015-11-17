//
//  SettingsViewController.swift
//  HMC Word Scroll
//
//  Created by Melody Sue on 10/9/15.
//  Copyright © 2015 HMC LAPDOG. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //UI Elements and defaults
    
    
    @IBOutlet weak var displaySpeedSwitch: UISwitch!
    
    @IBOutlet weak var label: UILabel!
    
    var colorThemes = ["Normal","Inverse","Sepia"]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorThemes.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return colorThemes[row]
    }
    
    @IBAction func speedSwitchChanged(sender: AnyObject) {
        if displaySpeedSwitch.on {
            label.text = "On"
        }
        else {
            label.text = "Off"
        }
    }
    
}
