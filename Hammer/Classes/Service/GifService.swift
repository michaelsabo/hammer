//
//  GifCollectionService.swift
//  Hammer
//
//  Created by Mike Sabo on 10/13/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Alamofire
import SwiftyJSON

class GifService {

	class func endpointForGifs() -> String {
		return "http://localhost:9292/api/gifs"
	}
	
	class func endpointForGifsFromTag(query: String) -> String{
		return "http://localhost:9292/api/gifs?q=" + query
	}
	
	func getGifsResponse(path: String) -> SignalProducer<[Gif], NSError> {
								print("IN THE SERVICE")
		return SignalProducer{ observer, disposable in
				Alamofire.request(.GET, path)
					.responseJSON { response in
						let json = JSON(response.result.value!)
						var allGifs:Array = Array<Gif>()
						let results = json["gifs"] as JSON
						var count = 0
						for jsonGif in results.arrayValue {
							let gif = Gif(json:jsonGif, index: count)
							allGifs.append(gif)
							count++
						}
						print("MAKES REQUEST AND GETS RESPONSE")
						if (response.result.isSuccess) {
							sendNext(observer, allGifs)
						} else {

						}
						
				}
		}
	}
	
}
