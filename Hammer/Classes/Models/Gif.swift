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

class Gif: NSObject {
	
	var id: String
	var url: String
	var thumbnailUrl: String
	var thumbnailImage: UIImage!
	var gifImage: UIImage!
	var index: Int!
	
	required init(json: JSON, index: Int) {
		self.id =  json["id"].stringValue
		self.url = json["url"].stringValue
		self.thumbnailUrl = json["thumbnail_url"].stringValue
		self.index = index
	}
	
	class func endpointForGifs() -> String {
		return "http://localhost:9292/api/gifs"
	}
	
	class func getGifs(completionHander: (GifsWrapper?, NSError?) -> Void) {
		getGifsAtPath(endpointForGifs(), completionHandler: completionHander)
	}
	
	private class func getGifsAtPath(path: String, completionHandler: (GifsWrapper?, NSError?) -> Void) {
		Alamofire.request(.GET, path)
			.responseJSON { response in
				let json = JSON(response.result.value!)
				let wrapper:GifsWrapper = GifsWrapper()
				var allGifs:Array = Array<Gif>()
				print(json)
				let results = json["gifs"] as JSON
				var count = 0
				for jsonGif in results.arrayValue {
					print(jsonGif)
					let gif = Gif(json:jsonGif, index: count)
					allGifs.append(gif)
					count++
				}
				wrapper.gifs = allGifs
				completionHandler(wrapper, nil)
		}
	}
	
	class func getThumbnailImageForGif(gif: Gif, completionHandler: (Gif?, NSError?) -> Void) {
		Alamofire.request(.GET, gif.thumbnailUrl)
			.responseData { response in
				if let data = response.result.value {
					gif.thumbnailImage = UIImage(data: data)
					completionHandler(gif, nil)
				} else {
					completionHandler(nil, nil)
				}
				
		}
	}
	
	class func getAnimatedGifForUrl(url: String, completionHandler: (UIImage?, NSError?) -> Void) {
		if let url = NSURL(string: url) {
			if let image = UIImage.animatedImageWithAnimatedGIFURL(url) {
					completionHandler(image, nil)
			} else {
				completionHandler(nil, nil)
			}
		
		}
	}

	
}

//let jsonData:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray
//let json = JSON(jsonData!)
//var wrapper:GifsWrapper = GifsWrapper()
//var allGifs:Array = Array<Gif>()
//print(json)
//let results = json["gifs"]
//
//for jsonGif in results {
//	print(jsonGif)
//	let gif = Gif(jsonGif)
//	allGifs.append(gif)
//}
//wrapper.gifs = allGifs




//extension Alamofire.Request {
//	func responseGifsArray(completionHandler: (NSURLRequest, NSHTTPURLResponse?, GifsWrapper?, NSError?) -> Void) -> Self {
//		let responseSerializer = GenericResponseSerializer<GifsWrapper> { request, response, data in
//			if let responseData = data {
//				 let jsonData:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray
////				if jsonData == nil || jsonData?.empty {
////					return (nil, nil)
////				}
////				
////				let json = JSON(jsonData!)
////				if json.error != nil || json == nil {
////					return (nil, json.error)
////				}
//				let error = NSError(domain: "com.domain.app", code: 1, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Health Data Not Available", comment: "")])
//
//				var wrapper:GifsWrapper = GifsWrapper()
//				var allGifs:Array = Array<Gif>()
//				print(json)
//				let results = json["gifs"]
//				
//				for jsonGif in results {
//					print(jsonGif)
//					let gif = Gif(jsonGif)
//					allGifs.append(gif)
//				}
//				wrapper.gifs = allGifs
//				return (allGifs, nil)
//			}
//		}
//		return response(responseSerializer: responseSerializer,
//			completionHandler: completionHandler)
//	}
//}