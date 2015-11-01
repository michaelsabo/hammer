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
	let tagComplete = MutableProperty(false)
	
	private let gifService: GifService
	private let tagService: TagService
	
	init(gifService: GifService, tagService: TagService, gif: Gif) {
		
		self.gifService = gifService
		self.tagService = tagService
		self.gif.value = gif
		super.init()
		
		gifService.retrieveImageDataFor(gif: gif)
			.take(1)
			.on(next: { [unowned self]
				response in
					guard (response.gifData != nil) else {
						return
					}
					self.gif.value = response
		}).start()
		
		tagService.getTagsForGifId(gif.id)
			.take(1)
			.on(next: { [unowned self]
				response in
					if (response.tags.count > 0) {
						self.tags.value = response.tags
					}
				self.tagComplete.value = true
			}).start()
	}
	
	lazy var tagsReturned: AnyProperty<Bool> = {
		let property = MutableProperty(false)
		
		property <~ self.tags.producer
			.filter { [unowned self] (value:[Tag]) in
				if (self.tagComplete.value == true) {
					return true
				}
				return false
			}
			.map { (value:[Tag]) in
				return true
		}
		return AnyProperty(property)
		
		}()
	
	lazy var imageReturned: SignalProducer<UIImage, NoError> = {
		return self.gif.producer
			.filter { $0.gifImage != nil }
			.map { [unowned self]  (value: Gif) -> UIImage in
				self.searchComplete.value = true
				if let image = value.gifImage {
					return image
				}
				return UIImage()
			}
		}()

	deinit {
		print("deiniting view model")
	}
}
	
	
	
