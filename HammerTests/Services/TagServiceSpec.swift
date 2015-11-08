//
//  TagServiceSpec.swift
//  Hammer
//
//  Created by Mike Sabo on 11/7/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import Hammer

class TagServiceSpec: QuickSpec {

  override func spec() {
    
    var tagService: MockTagService!
    beforeEach {
      tagService = MockTagService()
    }
    
    describe("Tag Service") {
     	
      it("should return the correct endpoint for all gifs") {
        expect(tagService.getEndpointForTags()).to(equal("http://ham-flyingdinos.rhcloud.com/api/tags"))
      }
      
      it("should return the correct endpoint for gif search") {
        expect(tagService.getEndpointForImageTags("my-query")).to(equal("http://ham-flyingdinos.rhcloud.com/api/gifs/my-query/tags"))
      }
      
      it("should return gifs in the response") {
        var tagsResponse : TagsResponse!
        waitUntil(timeout: 3.5) { done in
          tagService.getAllTags()
            .on(next: {
              tagsResponse = $0
              done()
            })
            .start()
          
        }
        expect(tagsResponse.tags.count).to(equal(8))
      }
      
      it("should return gifs for a tag search") {
        var tagsResponse : TagsResponse!
        waitUntil { done in
          tagService.getTagsForGifId("dadUkD4")
            .on(next: {
              tagsResponse = $0
              done()
            })
            .start()
        }
        expect(tagsResponse.tags.count).to(beGreaterThan(1))
      }
      
      it("should return no tags for an image without") {
        var tagsResponse : TagsResponse!
        waitUntil { done in
          tagService.getTagsForGifId("none")
            .on(next: {
              tagsResponse = $0
              done()
            })
            .start()
        }
        expect(tagsResponse.tags.count).to(equal(0))
      }
      
    }
  }
}
