//
//  UserStatsViewController.swift
//  HMC Word Scroll
//
//  Created by Melody Sue on 10/9/15.
//  Copyright © 2015 HMC LAPDOG. All rights reserved.
//

import UIKit

class UserStatsViewController: UIViewController {
    
    //UI Elements and defaults
    
    @IBOutlet weak var userStatsTitle: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var averageSpeedNumLabel: UILabel!
    @IBOutlet weak var totalWordsLabel: UILabel!
    @IBOutlet weak var totalWordsNumLabel: UILabel!
    @IBOutlet weak var numberArticlesLabel: UILabel!
    @IBOutlet weak var numberArticlesNumLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arr = [userStatsTitle,averageSpeedLabel,averageSpeedNumLabel,totalWordsLabel,totalWordsNumLabel,numberArticlesLabel,numberArticlesNumLabel]
        
        if Settings.currentTheme == "Inverse" {
            self.view.backgroundColor = UIColor.grayColor()
            for label in arr {
                label.textColor = UIColor.whiteColor()
            }
        }
        else if Settings.currentTheme == "Sepia" {
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
