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
    
    
    override func viewDidLoad() {
        idTextFieldItem.text=idNumber
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