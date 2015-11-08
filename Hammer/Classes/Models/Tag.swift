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
  
//  init(id: String, text: String) {
//    self.id =  id
//    self.text = text
//  }
}

class TagsResponse {
	var tags: [Tag]
  var response: ServiceResponse
	init (json: JSON) {
		self.tags = json["tags"].arrayValue.map { Tag(json: $0) }
    self.response = ServiceResponse.Success
	}
}
