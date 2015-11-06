//
//  ScrollingLabel.swift
//  ScrollingLabel
//
//  Created by Adam Shaw on 6/1/15.
//  Copyright (c) 2015 Adam Shaw. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import CoreMotion


public class ScrollingLabel: CustomStringConvertible {
    /*A label like object which holds a scrollview and a standard label. Scrolling is enabled
    via acclerometer control of the content offset of the scrollview. Various options
    are available for altering functionality/control of the label.*/
    
    //Instantiation of scroll view and label
    var baseTextLabel:UILabel!
    var baseScrollView:UIScrollView!
    var frame:CGRect!
    
    //Default variables for font size and text
    private static let sampleText:String="This is sample text for this scrolling label"
    private static let sampleFontSize:CGFloat=110
    private static let sampleFontName:String="Courier"
    private static let sampleFont:UIFont=UIFont(name:ScrollingLabel.sampleFontName,size:ScrollingLabel.sampleFontSize)!
    
    //Resizes label as needed when text is changed
    var text:String {
        get {
            return baseTextLabel.text ?? ScrollingLabel.sampleText
        }
        set(newText) {
            baseTextLabel.text=newText
            resizeLabelContentSize()
        }
    }
    
    var fontSize:CGFloat{
        get {
            return baseTextLabel.fontSize ?? ScrollingLabel.sampleFontSize
        }
        set(newSize) {
            let fontNameToImplement:String=self.fontName
            self.font=UIFont(name: fontNameToImplement, size: newSize)!
        }
    }
    
    var font:UIFont {
        get {
            return baseTextLabel.font ?? ScrollingLabel.sampleFont
        }
        set(newFont) {
            baseTextLabel.font=newFont
            let ratioOfFontSizeToLineHeight=baseTextLabel.fontSize/baseTextLabel.font.lineHeight
            if baseTextLabel.font.lineHeight>self.frame.height-self.labelYCoord*2 {
                baseTextLabel.fontSize=(self.frame.height-labelYCoord*2)*ratioOfFontSizeToLineHeight
            }
            labelYCoord=(frame.height-baseTextLabel.font.lineHeight)/2
            baseTextLabel.frame=CGRect(x: labelXCoord,y: labelYCoord,width: 0,height: 0)
            resizeLabelContentSize()
        }
    }
    
    var fontName:String{
        get {
            return baseTextLabel.font.fontName ?? ScrollingLabel.sampleFontName
        }
        set(newName) {
            let fontSizeToImplement:CGFloat=self.fontSize
            self.font=UIFont(name: newName, size: fontSizeToImplement)!
        }
    }
    
    //Border coloring for incorporated scroll view
    var cornerRadius:CGFloat=5
    var borderColor=UIColor.redColor()
    var backgroundColor=UIColor.whiteColor()
    var borderWidth:CGFloat=4
    
    //Location of the text view within the scroll view
    var labelXCoord:CGFloat=15
    var labelYCoord:CGFloat=15
    
    //Instantiation of accelerometer materials
    var motionManager=CMMotionManager()
    var queue=NSOperationQueue()
    var speed:CGFloat=1300
    var updateTimeInterval:NSTimeInterval=0.2
    var minTiltRequired:Double=0.005
    
    //Low Pass signal filter - not very useful for text difficulty testing
    var smoothAcceleration:Double=0
    var smoothingFactor:Double=0.15
    var smoothing:Bool=false
    
    //Variables affecting text/frame of text view
    var boundsScaleFactor:CGFloat=0.05
    var startWithTextOffScreen=true
    
    //Options for controlling user accelerometer input
    var invertTextMotion:Bool=true
    var pauseScrolling:Bool=false
    var upDownTilt:Bool=false
    var letUserCreateDefaultOrientation=true
    
    //Values for computing indices
    var characterSize:CGFloat!
    
    //Statistics tools, such as WPM and stopwatch instantiation
    var collectData:Bool=true
    var wordsPerMinute:Int=0
    var stopwatch:StopWatch=StopWatch()
    var timerStarted:Bool=false
    var progress:CGFloat=0
    let recordRawAcceleration:Bool=false
    
    //Keys: indices on screen. Values: accelerations at those indices
    var metricsDictionary=Dictionary<Suple<Double,Suple<Int,Int>>,Suple<Double,Double>>()
    
    //Controls when user starts and finishs
    var doneWithText:Bool=false
    
    //True: draws a box around text view, and displays current offsets
    private var PRIVATEDEBUG:Bool = false
    public var PUBLICDEBUG:Bool = false
    
    
    
    init(xPosition: CGFloat, yPosition: CGFloat, width: CGFloat, height: CGFloat) {
        /*Initializes the object by calling 3 private setup functions,
        each dealing one with a specific feature of the final label, and
        finally calling the scroll function to activate the accelerometer
        control*/
        setupFrame(xPosition, yPosition: yPosition, width: width, height: height)
        setupLabel()
        setupScrollView()
        startScrolling()
    }
    
    func kill() {
        //Deallocates the major elements from the scrolling label
        self.motionManager.stopAccelerometerUpdates()
        self.removeFromSuperview()
        self.baseTextLabel=nil
        self.baseScrollView=nil
        self.stopwatch.stop()
    }
    
    private func setupFrame(xPosition: CGFloat, yPosition: CGFloat, width: CGFloat, height: CGFloat) {
        let frame = CGRectMake(xPosition, yPosition, width, height)
        //Creates the frame of the label, and creates the child objects
        self.frame=frame
        if startWithTextOffScreen { labelXCoord += self.frame.width }
        baseTextLabel = UILabel(frame: CGRectMake(labelXCoord, labelYCoord, 0, 0))
        baseScrollView = UIScrollView(frame: frame)
        
        if PRIVATEDEBUG {PUBLICDEBUG=true}
    }
    
    private func setupScrollView() {
        //Sets up the scrollview which the label will be placed in
        baseScrollView.layer.cornerRadius = cornerRadius
        baseScrollView.layer.masksToBounds = true
        
        // Only mess with the border when we can't do blurring
        if UIAccessibilityIsReduceTransparencyEnabled() {
            baseScrollView.layer.borderColor=borderColor.CGColor
            baseScrollView.layer.borderWidth=borderWidth
            baseScrollView.layer.backgroundColor=backgroundColor.CGColor
        }
        
        baseScrollView.userInteractionEnabled = PRIVATEDEBUG
    }
    
    private func setupLabel() {
        //Sets up the label for the text, as well adding it to the scrollview
        baseTextLabel.textAlignment = .Left
        self.text = ScrollingLabel.sampleText
        self.font = ScrollingLabel.sampleFont
        baseScrollView.addSubview(baseTextLabel)
        if PRIVATEDEBUG {
            baseTextLabel.layer.borderWidth = 1
            baseTextLabel.layer.borderColor = UIColor.blueColor().CGColor
        }
        
    }
    
    private func startScrolling() {
        // The main accelerometer control of the label
        
        // Allows the start orientation to become default
        var firstOrientation: Bool
        if letUserCreateDefaultOrientation {
            firstOrientation = true
        } else {
            firstOrientation = false
        }
        var standardAccel: Double = 0
        var lastElapsedTime: Double = 0
        
        self.stopwatch.start()
        // Begins taking updates from the accelerometer
        if motionManager.accelerometerAvailable {
            motionManager.accelerometerUpdateInterval = updateTimeInterval
            motionManager.startAccelerometerUpdatesToQueue(self.queue, withHandler: {accelerometerData, error in
                    guard let accelerometerData = accelerometerData else {return}
                
                // Changes the input of acceleration depending on constant control variables
                var accel: Double
                if !self.upDownTilt {
                    if self.invertTextMotion {
                        accel = accelerometerData.acceleration.y
                    } else {
                        accel = -accelerometerData.acceleration.y
                    }
                }
                else {
                    if self.invertTextMotion {
                        accel = accelerometerData.acceleration.x
                    }
                    else {
                        accel = -accelerometerData.acceleration.x
                    }
                }
                
                // Sets the bounds of the label to prevent nil unwrapping
                let minXOffset: CGFloat = 0
                let maxXOffset = self.baseScrollView.contentSize.width - self.baseScrollView.frame.size.width

                // Changes default acceleration if allowed, but doesn't alter underlying option
                if firstOrientation {
                    standardAccel = accel
                    firstOrientation = false
                }
                accel = accel - standardAccel
                
                // If accel is greater than minimum, and label is not paused begin updates
                if !self.pauseScrolling && fabs(accel)>=self.minTiltRequired {
                    //If the timer has not started, and accel is positive, begin the timer
                    if !self.timerStarted&&accel<0{
                        self.stopwatch.start()
                        self.timerStarted=true
                    }
                    //Stores the data, and moves the scrollview depending on acceleration and constant speed
                    if self.smoothing {
                        accel=self.smoothAccel(accel)
                    }
                    if self.collectData {self.storeIndexAccelValues(accel,timeElapsed: self.stopwatch.elapsedTime,lastElapsedTime:lastElapsedTime)}
                    var targetX:CGFloat=self.baseScrollView.contentOffset.x+(CGFloat(accel) * self.speed)
                    if targetX > maxXOffset {
                        targetX = maxXOffset
                        self.haltScrollingLabel()
                    }
                    else if targetX < minXOffset {
                        targetX = minXOffset
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.baseScrollView.setContentOffset(CGPointMake(targetX, 0), animated:true)
                    }
                    if self.baseScrollView.contentOffset.x > minXOffset &&
                       self.baseScrollView.contentOffset.x < maxXOffset &&
                        self.PRIVATEDEBUG {
                        print(self.baseScrollView.contentOffset)
                    }
                }
                lastElapsedTime=self.stopwatch.elapsedTime
            })
        }
    }
    
    func smoothAccel(accel:Double) -> Double {
        //Low pass smoothing filter
        self.smoothAcceleration += (accel - self.smoothAcceleration)*self.smoothingFactor
        return self.smoothAcceleration
    }
    
    func haltScrollingLabel() {
        //Freezes the scrolling label
        self.stopwatch.stop()
        self.doneWithText=true
        self.motionManager.stopAccelerometerUpdates()
    }
    
    func restartScrollingLabel() {
        //Restarts the scrolling label
        if self.doneWithText {
            self.doneWithText=false
            self.stopwatch=StopWatch()
            self.timerStarted=false
            self.pauseScrolling=false
            self.startScrolling()
            self.metricsDictionary=Dictionary<Suple<Double,Suple<Int,Int>>,Suple<Double,Double>>()
        }
    }
    
    private func storeIndexAccelValues(accel:Double,timeElapsed:Double,lastElapsedTime:Double) {
        //Stores data relating character indexes to accelerometer values
        var startIndex:Int
        let endIndex:Int=Int(round(baseScrollView.contentOffset.x/self.characterSize))
        //If text is offscreen, index must be adjusted accordingle
        if baseScrollView.contentOffset.x<frame.width{
            startIndex=0
        }
        else {
            startIndex=Int(round((baseScrollView.contentOffset.x-frame.width)/(self.characterSize)))
        }
        //If the index has never been passed, instantiates its value as an empty array.
        if recordRawAcceleration {
            metricsDictionary[Suple(timeElapsed, Suple(startIndex,endIndex))]=Suple(accel,1)
        }
        else {
            let scalingFactor=Double(self.speed)/((timeElapsed-lastElapsedTime)*Double(self.characterSize))
            /*let distanceTravelled=CGFloat(accel)*self.speed
            let cgPointsPerSecond=Double(distanceTravelled)/(timeElapsed-lastElapsedTime)
            let charactersPerSecond=cgPointsPerSecond/Double(self.characterSize)*/
            metricsDictionary[Suple(timeElapsed, Suple(startIndex,endIndex))]=Suple(accel*scalingFactor,scalingFactor)
        }
    }
    
    func wordsTraversed() -> Int {
        //Uses ratios of CGFloats to find the farthest seen character index of the string
        var progressMade:CGFloat=self.baseScrollView.contentOffset.x
        if !startWithTextOffScreen {
            progressMade+=self.baseScrollView.frame.width
        }
        self.progress=progressMade/self.baseScrollView.contentSize.width
        let index=Int(self.progress*CGFloat(self.text.length))
        return self.text.findWordsBeforeIndex(index)
    }
    
    
    func updateTimerUI() {
        //Prints to the console various data about the reading so far
        if stopwatch.elapsedTime>=0.01 {
            print("-------------------")
            let traversed=wordsTraversed()
            print(stopwatch.timeIntervalToString()!)
            print(traversed)
            wordsPerMinute=60*traversed/max(1,Int(stopwatch.elapsedTime))
            print(wordsPerMinute)
            print("-------------------")
        }
    }
    
    public var description: String {
        return "Frame: \(self.frame.size)"
    }
    
    private func resizeLabelContentSize() {
        //Changes the baseLabel and contentSize according to fonts/sizes
        baseTextLabel.sizeToFit()
        var width=baseTextLabel.bounds.width+baseScrollView.bounds.width*boundsScaleFactor
        if width<baseScrollView.frame.width {width=baseScrollView.frame.width}
        if startWithTextOffScreen {
            width+=frame.width
        }
        baseScrollView.contentSize=(CGSize(width: width, height: baseTextLabel.bounds.height))
        let textLengthSize=Float(baseTextLabel.intrinsicContentSize().width)
        let textLength=Float(self.text.length)
        self.characterSize=CGFloat(textLengthSize/textLength)
        
    }
    
    func removeFromSuperview() {
        self.baseScrollView.removeFromSuperview()
    }
    
    func setContentOffset(pointToSetTo:CGPoint,animated:Bool) {
        self.baseScrollView.setContentOffset(pointToSetTo, animated: animated)
    }
    
}



