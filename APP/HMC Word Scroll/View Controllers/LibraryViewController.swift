//
//  LibraryViewController.swift
//  HMC Word Scroll
//
//  Created by Melody Sue on 12/5/15.
//  Copyright © 2015 HMC LAPDOG. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {
    
    //UI Elements and defaults
    @IBOutlet weak var libraryTitle: UILabel!
    @IBOutlet weak var importLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        
        let arr = [libraryTitle, importLabel]
        let arr2 = [searchButton]
        
        if Settings.currentTheme == "Inverse" {
            self.view.backgroundColor = UIColor.grayColor()
            
            for label in arr {
                label.textColor = UIColor.whiteColor()
            }
            for button in arr2 {
                button.tintColor = UIColor.yellowColor()
            }
        }
        else if Settings.currentTheme == "Sepia" {
            let swiftColor = UIColor(red: 253/255, green: 227/255, blue: 167/255, alpha: 1)
            
            self.view.backgroundColor = swiftColor
            
            for label in arr {
                label.textColor = UIColor.brownColor()
            }
            for button in arr2 {
                button.tintColor = UIColor.blueColor()
            }
        }
        else {
            self.view.backgroundColor = UIColor.whiteColor()
            
            for label in arr {
                label.textColor = UIColor.blackColor()
            }
            for button in arr2 {
                button.tintColor = UIColor.blueColor()
            }
        }
        
    }
    
    
    
}
