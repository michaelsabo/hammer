//
//  SearchTagViewModel.swift
//  Hammer
//
//  Created by Mike Sabo on 10/12/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import ReactiveCocoa

class HomeViewModel {

	let searchText = MutableProperty<String>("")
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
					if (response.gifs.count > 0) {
						self.gifCollection.value = response.gifs
					} else {
						print("SHITTTTT")
						self.gifCollection.value = [Gif]()
					}
			}))
		
		tagService.tagSignalProducer()
			.observeOn(QueueScheduler.mainQueueScheduler).start(Event.sink(error: {
				print("Error \($0)")
				}, next: {
					response in
					if (response.tags.count > 0) {
						self.allTags.value = response.tags
					}
				}))
	}

	
	lazy var searchingTagsSignal: SignalProducer<[Tag], NoError> = {
		return self.searchText.producer
			.filter { $0.characters.count > 1 }
			.map { (value: String) -> [Tag] in
				var matches = [Tag]()
				self.foundTags.value = [Tag]()
					self.isSearching.value = true
					for tag in self.allTags.value as [Tag] {
						if ((tag.text.lowercaseString.rangeOfString(value.lowercaseString)) != nil) {
							self.foundTags.value.append(tag)
						}
				}
				return matches
		}
	}()
	
	lazy var collectionUpdated: SignalProducer<[Gif], NoError> = {
		return self.gifCollection.producer
				.map { return $0 }
		
	}()
	
	
	lazy var tableWillHide: PropertyOf<Bool> = {
		let property = MutableProperty(false)
		property <~ self.searchText.producer
			.map {
				print(!(($0.characters.count > 1) && self.isSearching.value))
				return !(($0.characters.count > 1) && self.isSearching.value)
		}
		return PropertyOf(property)
	}()
	
	
	

}

