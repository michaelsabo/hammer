//
//  Tag.swift
//  Hammer
//
//  Created by Mike Sabo on 10/8/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


enum TagFields : String {
	case Id = "id"
	case Text = "text"
	case Tags = "tags"
}

class Tag {
	var id: String
	var text: String
	
	required init(json: JSON) {
		self.id = json[TagFields.Id.rawValue].stringValue
		self.text = json[TagFields.Text.rawValue].stringValue
	}
}

class TagWrapper : NSObject {
	
	class func getEndpointForImageTags(id : String) -> String {
		return "http://localhost:9292/api/gifs/\(id)/tags"
	}
	
	class func getEndpointForTags() -> String {
		return "http://localhost:9292/api/tags"
	}
	
	class func getTagsForImageId(id: String, completionHandler: ([Tag]?, Bool, NSError?) -> Void) {
		Alamofire.request(.GET, getEndpointForImageTags(id))
		.responseJSON { response in
				if (response.result.isSuccess) {
					let json = JSON(response.result.value!)
					var tagArray = [Tag]()
					let results = json[TagFields.Tags.rawValue] as JSON
					for jsonTag in results.arrayValue {
						let tag = Tag(json: jsonTag)
						tagArray.append(tag)
					}
					completionHandler(tagArray, response.result.isSuccess, nil)
					return
				} else {
					completionHandler(nil, response.result.isSuccess, response.result.error)
			}
		}
	}
	
	class func getAllTags(completionHandler: ([Tag]?, Bool, NSError?) -> Void) {
		Alamofire.request(.GET, getEndpointForTags())
			.responseJSON { response in
				if (response.result.isSuccess) {
					let json = JSON(response.result.value!)
					var tagArray = [Tag]()
					let results = json[TagFields.Tags.rawValue] as JSON
					for jsonTag in results.arrayValue {
						let tag = Tag(json: jsonTag)
						tagArray.append(tag)
					}
					completionHandler(tagArray, response.result.isSuccess, nil)
					return
				} else {
					completionHandler(nil, response.result.isSuccess, response.result.error)
				}
		}
	}
	
}