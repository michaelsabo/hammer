//
//  MockTagService.swift
//  Hammer
//
//  Created by Mike Sabo on 11/7/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation
import SwiftyJSON

class MockTagService: TagService {
  let tagsResponse = TagsResponse(json: JSON(data: TestingHelper.jsonFromFile("tags")))
  let taggedResponse = Tag(json: JSON(data: TestingHelper.jsonFromFile("tag")))

  override func getAllTags() -> SignalProducer<TagsResponse, NSError> {
    return SignalProducer { observer, _ in
      observer.sendNext(self.tagsResponse)
      observer.sendCompleted()
    }
  }

  override func getTagsForGifId(_ id: Int) -> SignalProducer<TagsResponse, NSError> {
    return SignalProducer { observer, _ in
      if id == 999 {
        observer.sendNext(TagsResponse())
        observer.sendCompleted()
        return
      }
      let stubbedTags = TagsResponse()
      for var i = 0; i < 3; i++ {
        stubbedTags.tags.append(self.tagsResponse.tags[i])
      }
      observer.sendNext(stubbedTags)
      observer.sendCompleted()
    }
  }

  override func tagGifWith(id _: Int, tag _: String) -> SignalProducer<Tag, NSError> {
    return SignalProducer { observer, _ in
      observer.sendNext(self.taggedResponse)
      observer.sendCompleted()
    }
  }
}
