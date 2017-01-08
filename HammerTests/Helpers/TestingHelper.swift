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
    
    class func jsonFromFile(_ filename: String) -> Data {
        if let filePath = Bundle(for: self).path(forResource: filename, ofType:"json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: filePath), options:NSData.ReadingOptions.uncached) {
                return data
            }
        }
        return Data.init()
    }
}
