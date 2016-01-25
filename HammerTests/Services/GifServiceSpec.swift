//
//  GifServiceSpec.swift
//  Hammer
//
//  Created by Mike Sabo on 11/7/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import Hammer

class GifServiceSpec: QuickSpec {

  override func spec() {
    
    var gifService: GifService!
    var gif: Gif!
    beforeEach {
      gifService = GifService()
      gif = Gif(id: 10, url: "http://i.imgur.com/p5tJEpm.gif", thumbnailUrl: "http://i.imgur.com/p5tJEpmb.gif", index: 0)
    }
    
    describe("Gif Service") {

      
      it("should return gifs in the response") {
        var gifsResponse = [Gif]()
        waitUntil(timeout: 15) { done in
          gifService.getGifsResponse()
            .on(next: {
              gifsResponse = $0.gifs
              done()
            })
            .start()

        }
        expect(gifsResponse.count).to(beGreaterThan(400))
       
      }
      
      it("should return gifs for a tag search") {
        let gifsResponse = Gifs()
        waitUntil(timeout: 15) { done in
          gifService.getGifsForTagSearchResponse("no")
            .on(next: {
              gifsResponse.gifs = $0.gifs
							done()
            })
            .start()
        }
        
        expect(gifsResponse.gifs.count).to(beGreaterThan(1))
      }
      
      it("should return an empty response for a bad search") {
        let gifsResponse = Gifs()
        waitUntil(timeout: 5) { done in
          gifService.getGifsForTagSearchResponse("xxxxxoko")
            .on(next: {
              gifsResponse.gifs = $0.gifs
            	done()
            })
            .start()
        }
        expect(gifsResponse.gifs.count).to(equal(0))
      }
      
      it("should return the thumbnail image") {
        expect(gif.thumbnailData).to(beNil())
        gifService.retrieveThumbnailImageFor(gif: gif)
          .on(next: { gif = $0 } )
        	.start()
        
        expect(gif.thumbnailData).toEventually(beTruthy(), timeout: 5)
      }
      
    }
  }

}
