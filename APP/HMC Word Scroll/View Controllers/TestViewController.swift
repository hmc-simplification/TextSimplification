//
//  TestViewController.swift
//  HMC Word Scroll
//
//  Created by Adam Shaw on 7/1/15.
//  Copyright (c) 2015 HMC LAPDOG. All rights reserved.
//

import UIKit
import Foundation

class TestViewController: UIViewController {
    
    @IBOutlet weak var speedDisplay: UILabel!
    
    //Initiates the timer and scrollingLabel of the view controller
    var scrollLabel:ScrollingLabel!
    var timer:NSTimer!
    var idNumber:String!
    
    
    //scrollLabel.sampleFontSize = Settings.fontSize
    
    //Start on iteration -1 for acclimation text
    var iteration:Int=(-1)
    
    var masterDataDictionary=Dictionary<String,String>()
    
    //Parameters about screen size
    let scrollLabelHeight:CGFloat=250
    let screenWidth:CGFloat=1024
    let screenHeight:CGFloat=768
    let frameSize:CGFloat=700

    var textDictionary:Dictionary<String,String>!

    //Next sample and proceed to MVC respectively
    @IBOutlet weak var softFinishButtonItem: UIButton!
    @IBOutlet weak var hardFinishButtonItem: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        //hardFinishButtonItem.hidden=true
        createScrollingLabel()
        
//        if Settings.displaySpeed == "On" {
//            speedDisplay.text = String(scrollLabel.speed)
//        }
//        else {
//            speedDisplay.text = ""
//        }
        
    }
    
    func createScrollingLabel() {
        //Creates the scrollLabel
        scrollLabel=ScrollingLabel(
            frame: CGRectMake((screenWidth-frameSize)/2,
                              screenHeight/2 - scrollLabelHeight/2,
                              frameSize,
                              scrollLabelHeight))
        resetScrollingLabelText()
        self.view.addSubview(scrollLabel)
    }
    
    func resetScrollingLabelText() {
        //Resets the position of the scrolling label and changes its text
        scrollLabel.text=getNextText()
        self.timer=NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("checkForCompletion"), userInfo: nil, repeats: true)
        //softFinishButtonItem.hidden=true
        scrollLabel.setContentOffset(CGPointZero,animated:false)
    }
    
    func getNextText() -> String {
        return Library.getTextById(Settings.currentTextID)
    }
    
    func checkForCompletion() {
        //If done with the text, depending on how many texts you have read, reveals a button and adds to the dictionary
        if scrollLabel.doneWithText {
            self.timer!.invalidate()
            masterDataDictionary["'\(Settings.currentTextID)'"] = scrollLabel.metricsDictionary.printDict()
            ++Library.iteration
            resetScrollingLabelText()
            scrollLabel.restartScrollingLabel()
            self.presentViewController(LibraryTableViewController(), animated:true, completion:nil)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Passes data to MVC
        if segue.identifier=="toMetricsViewController" {
            let mvc=segue.destinationViewController as! MetricsViewController
            mvc.accelerationData=self.masterDataDictionary
            mvc.idNumber=self.idNumber
            
        }
    }
    /*
    @IBAction func softFinishButton(sender: UIButton) {
        //Resets the label text and moves the scrollLabel to the correct position
        iteration++
        resetScrollingLabelText()
        scrollLabel.restartScrollingLabel()
    }*/

    
}
