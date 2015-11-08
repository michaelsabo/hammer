//
//  MockTagService.swift
//  Hammer
//
//  Created by Mike Sabo on 11/7/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation
import SwiftyJSON
import ReactiveCocoa


class MockTagService : TagService {
  
  let tagResponse =  TagsResponse(json: JSON(data: TestingHelper.jsonFromFile("tags")))
  
  
  override func getAllTags() -> SignalProducer<TagsResponse, NSError> {
    return SignalProducer { observer, disposable in
      observer.sendNext(self.tagResponse)
      observer.sendCompleted()
    }
  }
  
  override func getTagsForGifId(id: String) -> SignalProducer<TagsResponse, NSError> {
    return SignalProducer { observer, disposable in
      if (id == "none") {
        observer.sendNext(TagsResponse())
        observer.sendCompleted()
      	return
      }
      let stubbedTags = TagsResponse()
      for var i=0; i < 3; i++ {
        stubbedTags.tags.append(self.tagResponse.tags[i])
      }
      observer.sendNext(stubbedTags)
      observer.sendCompleted()
    }
  }
  
}