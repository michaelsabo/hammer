//
//  Gif.swift
//  Hammer
//
//  Created by Mike Sabo on 10/4/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import String_Extensions

enum GifFields: String {
	case Id = "id"
	case ImgurUrl = "url"
	case ImgurThumbnailUrl = "thumbnail_url"
}

class Gifs  {
	var gifs = [Gif]()
	var response: ServiceResponse

	init(gifsJSON: JSON) {
		var count = 0
		response = ServiceResponse.success
		gifs = removeDuplicates(gifsJSON["gifs"].arrayValue.map {
      let g = Gif(json: $0, index: count)
      count += 1
      return g
    })
	}
  
  init() {
    self.response = ServiceResponse.success
  }
  
}

class Gif: NSObject {
	
	var id: Int
	var url: String
	var thumbnailUrl: String
  var videoUrl: String
	var index: Int!
	var gifData: Data?
	var thumbnailData: Data?
  var showAnimation:Bool = true
	
	override init() {
		id = 0
		url = ""
		thumbnailUrl = ""
		index = 0
    videoUrl = ""
	}
	
	convenience init(json: JSON, index: Int) {
		self.init()
		self.id =  json[GifFields.Id.rawValue].intValue
		self.url = json[GifFields.ImgurUrl.rawValue].stringValue
    let chompedURL = self.url.chompLeft(".gif")
    self.videoUrl = "\(chompedURL).mp4"
		self.thumbnailUrl = json[GifFields.ImgurThumbnailUrl.rawValue].stringValue
		self.index = index
	}
  
  convenience init(id: Int, url: String, thumbnailUrl: String, index: Int) {
    self.init()
    self.id =  id
    self.url = url
    self.thumbnailUrl = thumbnailUrl
    self.index = index
    let chompedURL = self.url.chompLeft(".gif")
    self.videoUrl = "\(chompedURL).mp4"
  }
  
  override var hashValue : Int {
    get {
      return self.id.hashValue
    }
  }
  
}

func ==(lhs: Gif, rhs: Gif) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

extension Gifs {
  
  func removeDuplicates(_ collection: [Gif]) -> [Gif] {
    
    var keys = [Int]()
    var array = [Gif]()
    for gif in collection {
      if (keys.contains(gif.id)) {
        continue
      }
      keys.append(gif.id)
      array.append(gif)
    }
    return array
  }
  
}


