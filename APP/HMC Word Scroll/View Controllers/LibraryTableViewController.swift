//
//  LibraryTableViewController.swift
//  HMC Word Scroll
//
//  Created by Rachel Lee on 12/10/15.
//  Copyright © 2015 HMC LAPDOG. All rights reserved.
//

import UIKit

class Library {
    struct Static {
        //Different types of text
        static let testTextTypes:Array<String> = [
            "Test", "Semantics", "Syntactic", "Lexical"
        ]
        static var testTextVersion:String!
    
        //Randomly picks which version, A or B you will start with
        statuc var testTextVersionNumber:Int = Int(arc4random_uniform(2))
        static let testTextVersions:Array<String> = ["A", "B"]
    
        //The number of texts per text type
        static let numberOfTestTexts:Int = 4
        static var nextTestText:String!
        static var testTextType:String!

        //plist key for wikipedia stuff
        static let CONTENTS:String = "Contents"
    }

    static func getTextById(id: String) -> String {
        let name = id.substringToIndex(advance(id.endIndex, -6))
        let path = NSBundle.mainBundle().pathForResource(name, ofType:"plist")
        let myDict = NSDictionary(contentsOfFile: path!)
        let textDictionary = myDict as! Dictionary<String, String>         

        if contains(Static.testTextTypes, id) {
            // It is a test string
            Static.testTextVersionNumber = (Static.testTextVersionNumber + 1) % 2
            Static.testTextVersion = Static.testTextVersions[Static.testTextVersionNumber]
            if iteration == -1 {
                Static.nextTestText = "1A"
            } else {
                Static.nextTestText = String(
                    (iteration % Static.numberOfTestTexts) + 1) + 
                    Static.testTextVersion
                )    
            }
            return textDictionary[Static.nextTestText]!
        } else {
            return textDictionary[Static.CONTENTS]!
        }
    }
}

class LibraryTableViewController: UITableViewController {
    //folderName = "HMC Word Scroll.app"
    let paths = NSBundle.mainBundle().pathsForResourcesOfType("plist", inDirectory: nil)
    //let path = NSBundle.mainBundle().pathForResource("Test", ofType:"plist")
    
    //let fm = NSFileManager.defaultManager()
    //let path = NSBundle.mainBundle().resourcePath!
    //let items = try! fm.contentsOfDirectoryAtPath(path)
    
    //for item in items {
    //    if item.hasPrefix("nssl") {
    //    objects.append(item)
    //    }
    //}
    
    //var textArray: NSArray*/
    //var textArray:[String] = ["Hello", "world"]
    
    @IBOutlet weak var backbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //backbutton = self.navigationItem.leftBarButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return paths.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        //cell.textLabel?.text = self.textArray[indexPath.row]
        
        // Display the file name *.plist
        cell.textLabel?.text = paths[indexPath.row].componentsSeparatedByString(".app/")[1]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let cellName = cell.textLabel?.text
        Settings.currentTextID = cellName!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
