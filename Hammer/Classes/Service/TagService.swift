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

	
	func getEndpointForTags() -> String {
		return Request.forEndpoint("tags")
	}
	
	func getAllTags() -> SignalProducer<TagsResponse, NSError> {
		return SignalProducer {	sink, _ in
			Alamofire.request(.GET, getEndpointForTags())
				.responseJSON { response in
					if (response.result.isSuccess) {
						let tags = TagsResponse(json: JSON(response.result.value!))
						sendNext(sink, tags)
						sendCompleted(sink)
					} else {

					}
			}
			
		}
	}
	
	func getTagsForGifId(id: String) -> SignalProducer<TagsResponse, NSError> {
		return SignalProducer { sink, _ in
			Alamofire.request(.GET, TagWrapper.getEndpointForImageTags(id))
				.responseJSON { response in
					if (response.result.isSuccess) {
						let tags = TagsResponse(json: JSON(response.result.value!))
						sendNext(sink, tags)
						sendCompleted(sink)
					} else {

					}
			}
		}
	}
	
}
