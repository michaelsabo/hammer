//
//  TagAutocompleteService.swift
//  Hammer
//
//  Created by Mike Sabo on 10/12/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import ReactiveCocoa

class TagAutocompleteService {

	var tagResponse: TagsResponse?
	
	init() {

	}
	
	func tagSignalProducer() -> SignalProducer<TagsResponse, NSError> {
		return SignalProducer {
			sink, _ in
			dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { [unowned self] in
				TagWrapper.getAllTagsResponse( { (tags, isSuccess, error) in
					if (isSuccess) {
						if (tags != nil) {
							self.tagResponse = tags!
							sendCompleted(sink)
						}
					}
				})
			}
		}
	}
	

	
}
