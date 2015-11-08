//
//  TestingHelper.swift
//  Hammer
//
//  Created by Mike Sabo on 10/31/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation
import Hammer

class TestingHelper {
    
    class func jsonFromFile(filename: String) -> NSData {
        if let filePath = NSBundle(forClass: self).pathForResource(filename, ofType:"json") {
            if let data = try? NSData(contentsOfFile:filePath, options:NSDataReadingOptions.DataReadingUncached) {
                return data
            }
        }
        return NSData.init()
    }
}