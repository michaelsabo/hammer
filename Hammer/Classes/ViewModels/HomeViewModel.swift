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
	
	private let tagService: TagService
	private let gifService: GifService
	
	init(searchTagService: TagService, gifRetrieveService: GifService) {
		self.tagService = searchTagService
		self.gifService = gifRetrieveService
		
		gifService.getGifsResponse()
			.on(next: {
				response in
					if (response.gifs.count > 0) {
						self.gifCollection.value = response.gifs
						self.gifsForDisplay.value = response.gifs
					}
				})
				.start()
		
		tagService.getAllTags()
			.on(next: {
				response in
					if (response.tags.count > 0) {
						self.allTags.value = response.tags
					}
			})
			.start()
		
		isSearching.producer
			.start( {
				if ($0.value == false) {
					self.gifsForDisplay.value = self.gifCollection.value
				}
			})
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
		return self.gifsForDisplay.producer
			.map { return $0 }
		
		}()
	
	lazy var tableWillHide: AnyProperty<Bool> = {
		let property = MutableProperty(false)
		property <~ self.searchText.producer
			.map {
				return !(($0.characters.count > 1) && self.isSearching.value)
		}
		return AnyProperty(property)
		}()
	
	func getGifsForTagSearch() -> Void {
		gifService.getGifsForTagSearchResponse(self.searchText.value)
			.on(next: {
					response in
					if (response.gifs.count > 0) {
						self.gifsForDisplay.value = response.gifs
					} else {
						self.gifsForDisplay.value = [Gif]()
					}
			}).start()
	}
	
	func displayCellForGifs(indexPath indexPath: NSIndexPath, cell: ImageCell) -> ImageCell {
		if (indexPath.item < self.gifsForDisplay.value.count) {
			cell.imageView.layer.masksToBounds = true
			let gif = self.gifsForDisplay.value[indexPath.item]
			if let image = gif.thumbnailImage {
				cell.imageView.image = nil
				cell.imageView.image = image
				cell.imageView.layer.cornerRadius = 10.0
				cell.userInteractionEnabled = true
				return cell
			} else {
				dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
					Gif.getThumbnailImageForGif(gif, completionHandler: { [unowned self] (responseGif, isSuccess, error) in
						cell.imageView.layer.cornerRadius = 10.0
						if (isSuccess && !self.isSearching.value) {
							if let index = self.gifsForDisplay.value.indexOf(responseGif!) {
								self.gifsForDisplay.value[index].thumbnailImage = responseGif!.thumbnailImage
								cell.imageView.image = self.gifsForDisplay.value[index].thumbnailImage
								cell.imageView.layer.cornerRadius = 10.0
								cell.hasLoaded = true
							}
						} else if (isSuccess && self.isSearching.value) {
							if let index = self.gifsForDisplay.value.indexOf(responseGif!) {
								self.gifsForDisplay.value[index].thumbnailImage = responseGif!.thumbnailImage
								cell.imageView.image = self.gifsForDisplay.value[index].thumbnailImage
								cell.imageView.layer.cornerRadius = 10.0
								cell.hasLoaded = true
							}
						} else {
							cell.userInteractionEnabled = false
						}
						})
				}
			}
		}
		
		return cell
	}
	
	
	
}

