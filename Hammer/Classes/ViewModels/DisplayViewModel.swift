//
//  DisplayViewController.swift
//  Hammer
//
//  Created by Mike Sabo on 10/24/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MobileCoreServices

class DisplayViewModel : NSObject {
	
	let gif = MutableProperty<Gif>(Gif())
	let tags = MutableProperty<[Tag]>([Tag]())
	let searchComplete = MutableProperty(false)
	let tagComplete = MutableProperty(false)
	
  let gifRequestSignal: Signal<Bool, NoError>
  let tagRequestSignal: Signal<Bool, NoError>
  let createTagRequestSignal: Signal<Bool, NoError>
  
  private let gifRequestObserver: Observer<Bool, NoError>
  private let tagRequestObserver: Observer<Bool, NoError>
  private let createTagRequestObserver: Observer<Bool, NoError>
  
  var gifData : NSData!
  
	let gifService: GifService
  let tagService: TagService
	
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
    
    let (createTagSignal, createTagObserver) = Signal<Bool, NoError>.pipe()
    self.createTagRequestSignal = createTagSignal
    self.createTagRequestObserver = createTagObserver
    
    super.init()
    startGifImageSingal()
    startTagSignal()
	}
  
  func startGifImageSingal() {
    self.gifService.retrieveImageDataFor(gif: self.gif.value)
      .on(next: { [unowned self]
        response in
        guard (response != nil) else {
          return
        }
          self.gifData = NSData(data: response!)
        }, completed: { [unowned self] _ in
          self.gifRequestObserver.sendNext(true)
      }).start()
  }
  
  func startTagSignal() {
    self.tagService.getTagsForGifId(self.gif.value.id)
      .on(next: { [unowned self]
        response in
        if (response.tags.count > 0) {
          self.tags.value = response.tags
        }
        }, completed: { [unowned self] _ in
          self.tagRequestObserver.sendNext(true)
      }).start()
  }
  
  func startCreateTagSignalRequest(tagText: String ) {
    self.tagService.tagGifWith(id: self.gif.value.id, tag: tagText)
      .on(next: {
        response in
        
        }, completed: { [unowned self] in
          self.createTagRequestObserver.sendNext(true)
      }).start()
  }
  
  
  func cleanUpSignals() {
    self.gifRequestObserver.sendCompleted()
    self.tagRequestObserver.sendCompleted()
    self.createTagRequestObserver.sendCompleted()
  }
  
  func shareButtonClicked() {
    let pasteboard = UIPasteboard.generalPasteboard()
    pasteboard.persistent = true
    if let copiedGif = self.gif.value.gifData {
      pasteboard.setData(copiedGif, forPasteboardType: kUTTypeGIF as String)
    }
  }
  
  

	deinit {
		print("deiniting view model")
	}
}
	
	
	
