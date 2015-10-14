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
	
	func getGifsResponse(path: String) -> SignalProducer<GifResponse, NSError> {
		return SignalProducer{ sink, _ in
				Alamofire.request(.GET, path)
					.responseJSON { response in
						let gifs = GifResponse(gifsJSON: JSON(response.result.value!))
						if (response.result.isSuccess) {
							sendNext(sink, gifs)
							sendCompleted(sink)
						} else {

						}
						
				}
		}
	}
	
}
