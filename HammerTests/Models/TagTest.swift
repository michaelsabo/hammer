//
//  Tag.swift
//  Hammer
//
//  Created by Mike Sabo on 10/31/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import XCTest
import SwiftyJSON
import Hammer

class TagTest: XCTestCase {
    
    var json: JSON?
    override func setUp() {
        super.setUp()
        json = JSON(data: TestingHelper.jsonFromFile("tags"))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        let response = TagsResponse(json: json!)
        
        XCTAssertEqual(response.tags.count, 15)
        XCTAssertNotNil(response.tags[0].id)
        XCTAssertNotNil(response.tags[0].text)
        XCTAssertEqual(response.response, ServiceResponse.Success)
        
    }
    
}
