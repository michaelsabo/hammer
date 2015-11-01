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
	
  let gifRequestSignal: Signal<Bool, NoError>
  let tagRequestSignal: Signal<Bool, NoError>
  
  private let gifRequestObserver: Observer<Bool, NoError>
  private let tagRequestObserver: Observer<Bool, NoError>
  
	private let gifService: GifService
	private let tagService: TagService
	
	init(gifService: GifService, tagService: TagService, gif: Gif) {
		
		self.gifService = gifService
		self.tagService = tagService
		self.gif.value = gif
    
    let (gifSignal, gifObserver) = Signal<Bool, NoError>.pipe()
    self.gifRequestSignal = gifSignal
    self.gifRequestObserver = gifObserver
    
    let (tagSignal, tagObserver) = Signal<Bool, NoError>.pipe()
    self.tagRequestSignal = tagSignal
    self.tagRequestObserver = tagObserver
    
		super.init()
		
		gifService.retrieveImageDataFor(gif: gif)
			.on(next: { [unowned self]
				response in
					guard (response.gifData != nil) else {
						return
					}
					self.gif.value = response
        }, completed: {
          self.gifRequestObserver.sendNext(true)
      }).start()
		
		tagService.getTagsForGifId(gif.id)
			.on(next: { [unowned self]
				response in
					if (response.tags.count > 0) {
						self.tags.value = response.tags
					}
        }, completed: {
          self.tagRequestObserver.sendNext(true)
      }).start()
	}
	
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
	
	
	
