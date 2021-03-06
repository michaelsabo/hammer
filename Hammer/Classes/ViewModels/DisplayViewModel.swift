//
//  DisplayViewController.swift
//  Hammer
//
//  Created by Mike Sabo on 10/24/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation

import MobileCoreServices
import RxSwift
import Regift

class DisplayViewModel : NSObject {
	
  let gif :Gif!
	let tags = Variable<[Tag]>([])
  
	let searchComplete = Variable(false)
	let tagComplete = Variable(false)
  
  let createTagRequestSignal = Variable(false)

	
  let gifRequestSignal = Variable(false)
  let tagRequestSignal = Variable(false)
  
  let stopSignals = Variable(false)

  var videoSize:Int = 0
  var gifData : Data!
  var gifImage = Variable<UIImage?>(UIImage())
  
	var gifService: GifService
  var tagService: TagService
	
	init(gif: Gif) {
		self.gif = gif
    self.gifService = GifService()
    self.tagService = TagService()
    
    
    super.init()
    startGifImageSingal()
    startTagSignal()
	}
  
  func startGifImageSingal() {
    gifService.retrieveGifForVideo(gif, completion: { [weak self] success, data, videoSize in
      if let selfie = self, let gifData = data {
        selfie.gifData = gifData
        selfie.videoSize = videoSize
        selfie.gifRequestSignal.value = true
      }
    })
  }

  
  func startTagSignal() {
    self.tagService.getTagsForGifId(self.gif.id, completion: { [weak self] success, response in
      guard let selfie = self, let tags = response?.tags else { return }
      if (tags.count > 0) {
        selfie.tags.value = tags
        selfie.tagRequestSignal.value = true
      }
    })
  }
  
  var alertDetail : String  {
    let randomDetail = ["Aren't you a lyrical word smith?", "Think.....harderrrrr", "Is this the best you can do?", "Throw some fire on this?", "What would Shia Labeouf write?", "Try and think of how rainbows are made", "How do you sleep at night?"]
    let randomNumber = Int(arc4random_uniform(7))
    return randomDetail[randomNumber]
  }
  
  func startCreateTagSignalRequest(_ tagText: String ) {
    self.tagService.tagGifWith(self.gif.id, tag: tagText, completion: { [weak self] success, tag in
      guard let selfie = self else { return }
      selfie.createTagRequestSignal.value = true
    })
  }
  
  
  func stopServiceSignals() {
    stopSignals.value = true
  }

  
  

	deinit {
		print("deiniting view model")
	}
}
