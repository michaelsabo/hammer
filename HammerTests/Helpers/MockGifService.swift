//
//  MockGifService.swift
//  Hammer
//
//  Created by Mike Sabo on 11/7/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation
import SwiftyJSON
import ReactiveCocoa


class MockGifService : GifService {
  
  let gifResponse =  Gifs(gifsJSON: JSON(data: TestingHelper.jsonFromFile("gifs")))
	
  
  override func getGifsResponse() -> SignalProducer<Gifs, NSError> {
    return SignalProducer { observer, disposable in
      observer.sendNext(self.gifResponse)
      observer.sendCompleted()
    }
  }
  
  override func getGifsForTagSearchResponse(_ query: String) -> SignalProducer<Gifs, NSError> {
    return SignalProducer { observer, disposable in
    	let singleGif = Gifs()
      singleGif.gifs = [self.gifResponse.gifs[0]]
      observer.sendNext(singleGif)
      observer.sendCompleted()
    }
  }
  
  override func retrieveImageDataFor(gif: Gif) -> SignalProducer<NSData?, NSError> {
    return SignalProducer { observer, disposable in
      print("in here")
      let singleGif = self.gifResponse.gifs[0]
      observer.sendNext(singleGif.thumbnailData)
      observer.sendCompleted()
    }
  }
  
  override func retrieveThumbnailImageFor(gif: Gif) -> SignalProducer<Gif, NSError> {
    return SignalProducer { observer, disposable in
      let singleGif = self.gifResponse.gifs[0]
      observer.sendNext(singleGif)
      observer.sendCompleted()
    }
  }
  
}
