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
	case ImgurId = "id"
	case ImgurUrl = "url"
	case ImgurThumbnailUrl = "thumbnail_url"
}

class GifResponse {
	var gifs: [Gif]
	var response: ServiceResponse
	init(gifsJSON: JSON) {
		var count = 0
		response = ServiceResponse.Success
		gifs = gifsJSON["gifs"].arrayValue.map { Gif(json: $0, index: count++) }
	}
  
  init() {
    self.gifs = [Gif]()
    self.response = ServiceResponse.Success
  }
}

class Gif: Equatable {
	
	var id: String
	var url: String
	var thumbnailUrl: String
	var thumbnailImage: UIImage?
	var gifImage: UIImage?
	var index: Int!
	var gifData: NSData?
	var thumbnailData: NSData?
	
	init() {
		id = ""
		url = ""
		thumbnailUrl = ""
		index = 0
	}
	
	convenience init(json: JSON, index: Int) {
		self.init()
		self.id =  json[GifFields.ImgurId.rawValue].stringValue
		self.url = json[GifFields.ImgurUrl.rawValue].stringValue
		self.thumbnailUrl = json[GifFields.ImgurThumbnailUrl.rawValue].stringValue
		self.index = index
	}
  
  convenience init(id: String, url: String, thumbnailUrl: String, index: Int) {
    self.init()
    self.id =  id
    self.url = url
    self.thumbnailUrl = thumbnailUrl
    self.index = index
  }

	class func getThumbnailImageForGif(gif: Gif, completionHandler: (Gif?, Bool, NSError?) -> Void) {
		Alamofire.request(.GET, gif.thumbnailUrl)
			.responseData { response in
				if (response.result.isSuccess) {
					if let data = response.result.value {
						gif.thumbnailImage = UIImage(data: data)
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
	return lhs.id == rhs.id
}