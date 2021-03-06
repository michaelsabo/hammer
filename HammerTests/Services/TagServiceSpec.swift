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
        expect(tagsResponse.tags.count).to(equal(15))
      }
      
      it("should return gifs for a tag search") {
        var tagsResponse : TagsResponse!
        waitUntil { done in
          tagService.getTagsForGifId(10)
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
          tagService.getTagsForGifId(999)
            .on(next: {
              tagsResponse = $0
              done()
            })
            .start()
        }
        expect(tagsResponse.tags.count).to(equal(0))
      }
      
      it("should return the tag just created") {
        var taggedResponse : Tag!
        waitUntil { done in
          tagService.tagGifWith(id: 1111, tag: "custom-tag")
            .on(next: {
              taggedResponse = $0
              done()
            })
            .start()
        }
        expect(taggedResponse.id).to(equal(1111))
        expect(taggedResponse.text).to(equal("custom tag"))
      }

      
    }
  }
}
