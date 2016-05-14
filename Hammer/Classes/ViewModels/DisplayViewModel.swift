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
import Result

class DisplayViewModel : NSObject {
	
	let gif = MutableProperty<Gif>(Gif())
	let tags = MutableProperty<[Tag]>([Tag]())
	let searchComplete = MutableProperty(false)
	let tagComplete = MutableProperty(false)
  
	
  let gifRequestSignal: Signal<Bool, NoError>
  let tagRequestSignal: Signal<Bool, NoError>
  let createTagRequestSignal: Signal<Bool, NoError>
  let stopSignals : SignalProducer<(), NoError>
  
  private let gifRequestObserver: Observer<Bool, NoError>
  private let tagRequestObserver: Observer<Bool, NoError>
  private let createTagRequestObserver: Observer<Bool, NoError>
  private let stopSignalObserver: Observer<(), NoError>
  
  var gifData : NSData!
  var gifImage = MutableProperty<UIImage?>(UIImage())
  
	var gifService: GifService
  var tagService: TagService
	
	init(gif: Gif) {
		
    self.gifService = GifService()
    self.tagService = TagService()
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

    let (stopSignal, stopObserver) = SignalProducer<(), NoError>.buffer(5)
    self.stopSignals = stopSignal
    self.stopSignalObserver = stopObserver

    super.init()
    startGifImageSingal()
    startTagSignal()
	}
  
  func startGifImageSingal() {
    self.gifService.retrieveImageDataFor(gif: self.gif.value)
      .on(next: { [weak self]
        response in
        guard (response != nil) else {
          return
        }
          self?.gifData = NSData(data: response!)
        }, completed: { [weak self] _ in
          self?.gifRequestObserver.sendNext(true)
      }).takeUntil(self.stopSignals).start()
  }
  
  func startTagSignal() {
    self.tagService.getTagsForGifId(self.gif.value.id)
      .on(next: { [weak self]
        response in
        if (response.tags.count > 0) {
          self?.tags.value = response.tags
        }
        }, completed: { [weak self] _ in
          self?.tagRequestObserver.sendNext(true)
      }).takeUntil(self.stopSignals).start()
  }
  
  var alertDetail : String  {
    let randomDetail = ["Aren't you a lyrical word smith?", "Think.....harderrrrr", "Is this the best you can do?", "Throw some fire on this?", "What would Shia Labeouf write?", "Try and think of how rainbows are made", "How do you sleep at night?"]
    let randomNumber = Int(arc4random_uniform(7))
    return randomDetail[randomNumber]
  }
  
  func startCreateTagSignalRequest(tagText: String ) {
    self.tagService.tagGifWith(id: self.gif.value.id, tag: tagText)
      .on(next: {
        response in
        
        }, completed: { [weak self] in
          self?.createTagRequestObserver.sendNext(true)
      }).takeUntil(self.stopSignals).start()
  }
  
  
  func stopServiceSignals() {
    self.stopSignalObserver.sendNext()
  }

  
  

	deinit {
		print("deiniting view model")
	}
}
	
	
	
