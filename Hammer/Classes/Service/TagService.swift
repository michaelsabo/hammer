//
//  TagAutocompleteService.swift
//  Hammer
//
//  Created by Mike Sabo on 10/12/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import ReactiveCocoa
import Alamofire
import SwiftyJSON

class TagService {

	
	func endpointForTags() -> String {
		return Request.forEndpoint("tags")
	}
	
	func endpointForGifTags(id : String) -> String {
		return Request.forEndpoint("gifs/\(id)/tags")
	}
  
  func endpointForTaggingGifWith(id id : String, tag: String) -> String {
    return "\(endpointForGifTags(id))/\(tag)"
  }
	
  func tagGifWith(id id : String, tag: String) -> SignalProducer<Tag, NSError> {
		return SignalProducer { 	observer, disposable in
      Alamofire.request(.POST, self.endpointForTaggingGifWith(id: id, tag: tag))
				.responseJSON { response in
					if (response.result.isSuccess) {
            let json = JSON(response.result.value!)
						let tag = Tag(json: json["tag"])
            observer.sendNext(tag)
            observer.sendCompleted()
					} else {

					}
			}
		}
	}
  
  func getAllTags() -> SignalProducer<TagsResponse, NSError> {
    return SignalProducer { 	observer, disposable in
      Alamofire.request(.GET, self.endpointForTags())
        .responseJSON { response in
          if (response.result.isSuccess) {
            let tags = TagsResponse(json: JSON(response.result.value!))
            observer.sendNext(tags)
            observer.sendCompleted()
          } else {

          }
      }
      
    }
  }
	
	func getTagsForGifId(id: Int) -> SignalProducer<TagsResponse, NSError> {
		return SignalProducer {  observer, disposable in
			Alamofire.request(.GET, self.endpointForGifTags(id))
				.responseJSON { response in
					if (response.result.isSuccess) {
						let tags = TagsResponse(json: JSON(response.result.value!))
						observer.sendNext(tags)
						observer.sendCompleted()
					} else {

					}
			}
		}
	}
	
}
