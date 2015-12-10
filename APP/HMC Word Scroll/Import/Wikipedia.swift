//
//  Wikipedia.swift
//  HMC Word Scroll
//
//  Created by Rachel Lee on 12/9/15.
//  Copyright © 2015 HMC LAPDOG. All rights reserved.
//

import Foundation

func getArticle() {
    let url = NSURL(string: "https://en.wikipedia.org/wiki/Special:Export/Basketball")
    let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
        print(NSString(data: data!, encoding: NSUTF8StringEncoding))
    }
    
    task.resume()
}