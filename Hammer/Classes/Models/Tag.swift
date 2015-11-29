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
  case Name = "name"
}

class Tag {
	var id: Int
	var text: String
  var name: String
	
	required init(json: JSON) {
		self.id = json[TagFields.Id.rawValue].intValue
		self.text = json[TagFields.Text.rawValue].stringValue
    self.name = json[TagFields.Name.rawValue].stringValue
	}
  
  init(id: Int, text: String, name: String) {
    self.id =  id
    self.text = text
    self.name = name
  }
}

class TagsResponse {
	var tags: [Tag]
  var response: ServiceResponse
	init (json: JSON) {
		self.tags = json["tags"].arrayValue.map { Tag(json: $0) }
    self.response = ServiceResponse.Success
	}
  init () {
    self.tags = [Tag]()
    self.response = ServiceResponse.Success
  }
}
