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
	let allTags =  MutableProperty<[Tag]>([Tag]())
	
	private let tagService: TagAutocompleteService
	
	init(searchTagService: TagAutocompleteService, tags: [Tag]?) {
		self.tagService = searchTagService
		
		let _ = MutableProperty<String>("")
		
		isValidSearch <~ searchText.producer.map { $0.characters.count > 1 }
		
		
		
		
		}

}

