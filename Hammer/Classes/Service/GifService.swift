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
	
	func getGifsResponse() -> SignalProducer<Gifs, NSError> {
		return SignalProducer{ observer, disposable in
				Alamofire.request(Router.Gifs)
					.responseJSON { response in
						if let json = response.result.value {
							let gifs = Gifs(gifsJSON: JSON(json))
							if (response.result.isSuccess) {
								observer.sendNext(gifs)
								observer.sendCompleted()
							}
						} else {

						}
						
				}
		}
	}
	
	func getGifsForTagSearchResponse(query: String) -> SignalProducer<Gifs, NSError> {
		return SignalProducer{  observer, disposable in
      print(Router.GifsForTag(query).URL)
			Alamofire.request(Router.GifsForTag(query))
				.responseJSON { response in
					if let json = response.result.value {
						let gifs = Gifs(gifsJSON: JSON(json))
						if (response.result.isSuccess) {
							observer.sendNext(gifs)
							observer.sendCompleted()
						}
					} else {
						
					}
					
			}
		}
	}
	
	func retrieveThumbnailimageFor(gif gif: Gif) -> SignalProducer<Gif, NSError> {
		return SignalProducer { observer, disposable in
			Alamofire.request(.GET, gif.thumbnailUrl)
				.responseData { response in
					if (response.result.isSuccess) {
						if let data = response.result.value {
              gif.thumbnailData = UIImageJPEGRepresentation(UIImage(data: data)!, 0.1)
							observer.sendNext(gif)
							observer.sendCompleted()
						}
					} else {
						
					}
			}
		}
	}
	
	func retrieveImageDataFor(gif gif: Gif) -> SignalProducer<NSData?, NSError> {
		return SignalProducer { observer, disposable in
			Alamofire.request(.GET, gif.url)
				.responseData { response in
					if (response.result.isSuccess) {
						if let data = response.result.value {
//							gif.gifData = data
//							gif.gifImage = UIImage.animatedImageWithAnimatedGIFData(data)
							observer.sendNext(data)
							observer.sendCompleted()
						}
					} else {
						
					}
			}
		}
	}
  
  func addGif(id id : String) -> SignalProducer<Bool, NSError> {
    return SignalProducer { 	observer, disposable in
      Alamofire.request(Router.AddGif(id))
        .responseJSON { response in
          if (response.result.isSuccess) {
//            let json = JSON(response.result.value!)
//            let gif = Gif(json: json["gif"], index: 0)
            observer.sendNext(true)
            observer.sendCompleted()
          } else {
            
          }
      }
    }
  }
	
	
}

extension String {
	
	mutating func replaceSpaces() -> String {
		return self.stringByReplacingOccurrencesOfString(" ", withString: "-")
	}
	
}
