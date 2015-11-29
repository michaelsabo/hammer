//
//  Gif.swift
//  Hammer
//
//  Created by Mike Sabo on 10/31/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import XCTest
import SwiftyJSON
import Hammer

class GifTest: XCTestCase {
	
		var json: JSON?
    override func setUp() {
        super.setUp()
        json = JSON(data: TestingHelper.jsonFromFile("gifs"))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
    	let response = Gifs(gifsJSON: json!)
    	
    	XCTAssertEqual(response.gifs.count, 17)
    	XCTAssertNotNil(response.gifs[0].id)
      XCTAssertNotNil(response.gifs[0].thumbnailUrl)
    	XCTAssertNotNil(response.gifs[0].url)
      XCTAssertEqual(response.response, ServiceResponse.Success)
        
		}
    
}
