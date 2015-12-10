//
//  Library.swift
//  HMC Word Scroll
//
//  Created by Rachel Lee on 12/10/15.
//  Copyright © 2015 HMC LAPDOG. All rights reserved.
//

import Foundation

class Library
{
    // Variables
    var title: String
    var path: String
    var description: String
    
    init(title: String, path: String, description: String)
    {
        self.title = title
        self.path = path
        self.description = description
    }
}