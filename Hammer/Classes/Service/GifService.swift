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

	func endpointForGifs() -> String {
			return Request.forEndpoint("gifs")
	}
	
	func endpointForGifsFromTag(query: String) -> String{
		return Request.forEndpoint("gifs?q=\(query)")
	}

	
	func getGifsResponse() -> SignalProducer<GifResponse, NSError> {
		return SignalProducer{ [unowned self]sink, _ in
				Alamofire.request(.GET, self.endpointForGifs())
					.responseJSON { response in
						if let json = response.result.value {
							let gifs = GifResponse(gifsJSON: JSON(json))
							if (response.result.isSuccess) {
								sink.sendNext(gifs)
								sink.sendCompleted()
							}
						} else {

						}
						
				}
		}
	}
	
	func getGifsForTagSearchResponse(query: String) -> SignalProducer<GifResponse, NSError> {
		return SignalProducer{ [unowned self] sink, _ in
			Alamofire.request(.GET, self.endpointForGifsFromTag(query))
				.responseJSON { response in
					if let json = response.result.value {
						let gifs = GifResponse(gifsJSON: JSON(json))
						if (response.result.isSuccess) {
							sink.sendNext(gifs)
							sink.sendCompleted()
						}
					} else {
						
					}
					
			}
		}
	}
	
	func retrieveThumbnailimageFor(gif gif: Gif) -> SignalProducer<Gif, NSError> {
		return SignalProducer { sink, _ in
			Alamofire.request(.GET, gif.thumbnailUrl)
				.responseData { response in
					if (response.result.isSuccess) {
						if let data = response.result.value {
							gif.thumbnailImage = UIImage(data: data)
							sink.sendNext(gif)
							sink.sendCompleted()
						}
					} else {
						
					}
			}
		}
	}
	
	func retrieveImageDataFor(gif gif: Gif) -> SignalProducer<Gif, NSError> {
		return SignalProducer { sink, _ in
			Alamofire.request(.GET, gif.url)
				.responseData { response in
					if (response.result.isSuccess) {
						if let data = response.result.value {
							gif.gifData = data
							gif.gifImage = UIImage.animatedImageWithAnimatedGIFData(data)
							sink.sendNext(gif)
							sink.sendCompleted()
						}
					} else {
						
					}
			}
		}
	}
	
	
}
