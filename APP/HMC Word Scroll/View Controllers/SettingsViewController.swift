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
    
    @IBOutlet weak var fontSizeStepper: UIStepper!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var themesLabel: UILabel!
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var fontSizeLabel2: UILabel!
    @IBOutlet weak var displaySpeedLabel: UILabel!
    @IBOutlet weak var fixedSpeedLabel: UILabel!
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        fontSizeLabel2.text = Int(sender.value).description
    }
    
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
    
    // Capture the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        NSUserDefaults.standardUserDefaults().setObject(colorThemes[row], forKey: "theme")
        let currentTheme = NSUserDefaults.standardUserDefaults().objectForKey("theme")! as! NSString
        
        let arr = [settingsLabel, themesLabel, fontSizeLabel, fontSizeLabel2,displaySpeedLabel,fixedSpeedLabel]
        
        if currentTheme == "Inverse" {
            self.view.backgroundColor = UIColor.grayColor()
            
            
            for label in arr {
                label.textColor = UIColor.whiteColor()
            }
        }
        else if currentTheme == "Sepia" {
            let swiftColor = UIColor(red: 253/255, green: 227/255, blue: 167/255, alpha: 1)
            
            self.view.backgroundColor = swiftColor
            
            for label in arr {
                label.textColor = UIColor.brownColor()
            }
        }
        else {
            self.view.backgroundColor = UIColor.whiteColor()
            
            for label in arr {
                label.textColor = UIColor.blackColor()
            }
        }
        
    }
    
    @IBAction func speedSwitchChanged(sender: AnyObject) {
        if displaySpeedSwitch.on {
            label.text = "On"
        }
        else {
            label.text = "Off"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fontSizeStepper.wraps = true
        fontSizeStepper.autorepeat = true
        fontSizeStepper.maximumValue = 130
        fontSizeStepper.minimumValue = 80
    }
    
    
}
