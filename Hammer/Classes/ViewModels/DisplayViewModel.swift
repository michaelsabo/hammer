//
//  DisplayViewController.swift
//  Hammer
//
//  Created by Mike Sabo on 10/24/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation
import ReactiveCocoa

class DisplayViewModel : NSObject {
	
	
	let gif = MutableProperty<Gif>(Gif())
	let tags = MutableProperty<[Tag]>([Tag]())
	let searchComplete = MutableProperty(false)
	
	private let gifService: GifService
	private let tagService: TagService
	
	init(gifService: GifService, tagService: TagService, gif: Gif) {
		
		self.gifService = gifService
		self.tagService = tagService
		self.gif.value = gif
		super.init()
		
		gifService.retrieveImageDataFor(gif: gif)
			.observeOn(QueueScheduler.mainQueueScheduler).start(Event.sink(error: {
					print("Error \($0)")
				},
				next: {
					response in
					guard (response.gifData != nil) else {
						return
					}
					self.gif.value = response
		}))
		
		tagService.getTagsForGifId(gif.id)
			.observeOn(QueueScheduler.mainQueueScheduler).start(Event.sink(error: {
				print("Error \($0)")
				}, next: {
					response in
					if (response.tags.count > 0) {
						self.tags.value = response.tags
					}
			}))
	}
	
	lazy var tagsUpdated: SignalProducer<[Tag], NoError> = {
		return self.tags.producer
			.map { return $0 }
		
		}()
	
	lazy var imageReturned: SignalProducer<UIImage, NoError> = {
		return self.gif.producer
			.filter { $0.gifImage != nil }
			.map { (value: Gif) -> UIImage in
				self.searchComplete.value = true
				if let image = value.gifImage {
					return image
				}
				return UIImage()
			}
		}()
	
	
	
}