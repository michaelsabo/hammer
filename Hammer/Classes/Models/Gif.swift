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
		response = ServiceResponse.Success
		gifs = removeDuplicates(gifsJSON["gifs"].arrayValue.map { Gif(json: $0, index: count++) })
	}
  
  init() {
    self.response = ServiceResponse.Success
  }
  
}

class Gif: NSObject {
	
	var id: Int
	var url: String
	var thumbnailUrl: String
	var index: Int!
	var gifData: NSData?
	var thumbnailData: NSData?
	
	override init() {
		id = 0
		url = ""
		thumbnailUrl = ""
		index = 0
	}
	
	convenience init(json: JSON, index: Int) {
		self.init()
		self.id =  json[GifFields.Id.rawValue].intValue
		self.url = json[GifFields.ImgurUrl.rawValue].stringValue
		self.thumbnailUrl = json[GifFields.ImgurThumbnailUrl.rawValue].stringValue
		self.index = index
	}
  
  convenience init(id: Int, url: String, thumbnailUrl: String, index: Int) {
    self.init()
    self.id =  id
    self.url = url
    self.thumbnailUrl = thumbnailUrl
    self.index = index
  }
  
  override var hashValue : Int {
    get {
      return self.id.hashValue
    }
  }

	class func getThumbnailImageForGif(gif: Gif, completionHandler: (Gif?, Bool, NSError?) -> Void) {
		Alamofire.request(.GET, gif.thumbnailUrl)
			.responseData { response in
				if (response.result.isSuccess) {
					if let data = response.result.value {
            let compressed = UIImageJPEGRepresentation(UIImage(data: data)!, 0.10)!
						gif.thumbnailData = compressed
						completionHandler(gif, response.result.isSuccess, nil)
						return
					}
				} else {
					completionHandler(nil, response.result.isSuccess, response.result.error)
				}
		}
	}
  
  
}

func ==(lhs: Gif, rhs: Gif) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

extension Gifs {
  
  func removeDuplicates(collection: [Gif]) -> [Gif] {
    
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


