//
//  IntroViewController.swift
//  HMC Word Scroll
//
//  Created by Adam Shaw on 7/1/15.
//  Copyright (c) 2015 HMC LAPDOG. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    //First view controller to select ID number and begin tests
    
    //UI Elements and defaults
    var idNumber:String="0"
    @IBOutlet weak var idTextFieldItem: UITextField!
    
    @IBOutlet weak var textScrollTitle: UILabel!
    @IBOutlet weak var text1: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var instructButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    
    override func viewDidLoad() {
        idTextFieldItem.text=idNumber
        
        let arr = [textScrollTitle, text1]
        let arr2 = [startButton, resumeButton, instructButton,libraryButton,statsButton]
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="toTestViewController" {
            let tvc=segue.destinationViewController as! TestViewController
            tvc.idNumber=idTextFieldItem.text
        }
    }
    
    @IBAction func hardResetToIntroViewController(segue:UIStoryboardSegue) {
        //Unwind segue from testViewController
        if segue.sourceViewController.isKindOfClass(TestViewController) {
            let tvc=segue.sourceViewController as! TestViewController
            tvc.scrollLabel.kill()
            tvc.timer!.invalidate()
            
        }
    }
    
    @IBAction func transitionToTVCButton(sender: UIButton) {
        //Go to TVC if ID!='0'
        if !(idTextFieldItem.text=="0") {
            performSegueWithIdentifier("toTestViewController",sender:nil)
        }
    }
    
    
    
}