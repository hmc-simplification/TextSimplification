//
//  MetricsViewController.swift
//  HMC Word Scroll
//
//  Created by Adam Shaw on 7/1/15.
//  Copyright (c) 2015 HMC LAPDOG. All rights reserved.
//

import UIKit
import MessageUI

class MetricsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var thankTitle: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    
    //Sends off the data in an email, if available
    
    var accelerationData:Dictionary<String,String>!
    var idNumber:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if MFMailComposeViewController.canSendMail() {
            let emailer = MFMailComposeViewController()
            emailer.mailComposeDelegate=self
            emailer.setSubject("ID Number: \(idNumber)")
            emailer.setMessageBody(accelerationData.printDict(),isHTML:false)
            emailer.setToRecipients(["text.difficulty.data.hmc@gmail.com"])
            self.presentViewController(emailer,animated:true,completion:nil)
        }
        
        if Settings.currentTheme == "Inverse" {
            self.view.backgroundColor = UIColor.grayColor()
            thankTitle.textColor = UIColor.whiteColor()
            resetButton.tintColor = UIColor.yellowColor()
        }
        else if Settings.currentTheme == "Sepia" {
            let swiftColor = UIColor(red: 253/255, green: 227/255, blue: 167/255, alpha: 1)
            self.view.backgroundColor = swiftColor
            thankTitle.textColor = UIColor.brownColor()
            resetButton.tintColor = UIColor.blueColor()
        }
        else {
            thankTitle.textColor = UIColor.blackColor()
            resetButton.tintColor = UIColor.blueColor()
        }
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}