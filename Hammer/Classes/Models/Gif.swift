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

class Gif: NSObject {
	
	var id: String
	var url: String
	var thumbnailUrl: String
	var thumbnailImage: UIImage!
	var gifImage: UIImage!
	var index: Int!
	
	required init(json: JSON, index: Int) {
		self.id =  json[GifFields.ImgurId.rawValue].stringValue
		self.url = json[GifFields.ImgurUrl.rawValue].stringValue
		self.thumbnailUrl = json[GifFields.ImgurThumbnailUrl.rawValue].stringValue
		self.index = index
	}
	
	class func endpointForGifs() -> String {
		return "http://localhost:9292/api/gifs"
	}
	
	class func getGifs(completionHander: ([Gif]?, Bool, NSError?) -> Void) {
		getGifsAtPath(endpointForGifs(), completionHandler: completionHander)
	}
	
	private class func getGifsAtPath(path: String, completionHandler: ([Gif]?, Bool, NSError?) -> Void) {
		Alamofire.request(.GET, path)
			.responseJSON { response in
				if (response.result.isSuccess) {
					let json = JSON(response.result.value!)
					var allGifs:Array = Array<Gif>()
					let results = json["gifs"] as JSON
					var count = 0
					for jsonGif in results.arrayValue {
						let gif = Gif(json:jsonGif, index: count)
						allGifs.append(gif)
						count++
					}
					completionHandler(allGifs, response.result.isSuccess, nil)
					return
				}
				completionHandler([Gif](), response.result.isSuccess, response.result.error)
		}
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
	
	class func getAnimatedGifForUrl(url: String, completionHandler: (UIImage?, Bool, NSError?) -> Void) {
		if let url = NSURL(string: url) {
			if let image = UIImage.animatedImageWithAnimatedGIFURL(url) {
					completionHandler(image, true, nil)
			} else {
				completionHandler(nil, false, nil)
			}
		
		}
	}
}