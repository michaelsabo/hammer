//
//  SearchTagViewModel.swift
//  Hammer
//
//  Created by Mike Sabo on 10/12/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SearchTagViewModel {

	let searchText = MutableProperty<String>("")
	let isValidSearch = MutableProperty<Bool>(false)
	let isSearching = MutableProperty<Bool>(false)
	
	let foundTags = MutableProperty<[Tag]>([Tag]())
	var allTags =  MutableProperty<[Tag]>([Tag]())
	
	var gifCollection = MutableProperty<[Gif]>([Gif]())
	var gifsForDisplay = MutableProperty<[Gif]>([Gif]())
	
	private let tagService: TagAutocompleteService
	private let gifService: GifService
	
	init(searchTagService: TagAutocompleteService, gifRetrieveService: GifService) {
		self.tagService = searchTagService
		self.gifService = gifRetrieveService
		
		gifService.getGifsResponse(GifService.endpointForGifs())
			.observeOn(QueueScheduler.mainQueueScheduler).start(Event.sink(error: {
				print("Error \($0)")
				},
				next: {
					response in
					print(response)
					if (response.count > 0) {
						self.gifCollection.value = response
					} else {
						print("SHITTTTT")
						self.gifCollection.value = [Gif]()
					}
			}))
		


		isValidSearch <~ searchText.producer.map { $0.characters.count > 1 }

	}

	
	lazy var searchingTagsSignal: SignalProducer<[Tag], NoError> = {
		return self.searchText.producer
			.map { (value: String) -> [Tag] in
				var matches = [Tag]()
				self.foundTags.value = [Tag]()
				if (self.isValidSearch.value) {
					self.isSearching.value = true
					for tag in self.allTags.value as [Tag] {
						if ((tag.text.lowercaseString.rangeOfString(value.lowercaseString)) != nil) {
							self.foundTags.value.append(tag)
						}
					}
				}
				return matches
		}
	}()
	
	
	lazy var tableWillHide: PropertyOf<Bool> = {
		let property = MutableProperty(false)
		property <~ self.searchText.producer
			.map {
				return !(($0.characters.count > 1) && self.isSearching.value)
		}
		return PropertyOf(property)
	}()
	
	
	

}

