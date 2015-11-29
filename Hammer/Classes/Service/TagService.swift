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


	
	func getAllTags() -> SignalProducer<TagsResponse, NSError> {
		return SignalProducer { 	observer, disposable in
			Alamofire.request(Router.Tags)
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
			Alamofire.request(Router.TagsForGif(id))
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
