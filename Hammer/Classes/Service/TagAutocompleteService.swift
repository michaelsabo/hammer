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

class TagAutocompleteService {

	
	func getEndpointForTags() -> String {
		return "http://ham-flyingdinos.rhcloud.com/api/tags"
	}
	
	func tagSignalProducer() -> SignalProducer<TagsResponse, NSError> {
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
	

	
}
