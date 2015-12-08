//
//  InstructionsViewController.swift
//  HMC Word Scroll
//
//  Created by Melody Sue on 10/9/15.
//  Copyright © 2015 HMC LAPDOG. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    
    //UI Elements and defaults

    @IBOutlet weak var titleInstruc: UILabel!
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var text3: UILabel!
    @IBOutlet weak var text4: UILabel!
    @IBOutlet weak var text5: UILabel!
    
    override func viewDidLoad() {
        let currentTheme = Settings.currentTheme
        print(currentTheme)
        
        let arr = [titleInstruc, text1, text2, text3, text4, text5]
        
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
    
    
    
}
