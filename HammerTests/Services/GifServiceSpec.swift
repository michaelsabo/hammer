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

class GifServiceSpec: QuickSpec {

  override func spec() {
    
//    var gifService: GifService!
//    var gif: Gif!
//    beforeEach {
//      gifService = GifService()
//      gif = Gif(id: "p5tJEpm", url: "http://i.imgur.com/p5tJEpm.gif", thumbnailUrl: "http://i.imgur.com/p5tJEpmb.gif", index: 0)
//    }
//    
//    describe("Gif Service") {
//     	
//      it("should return the correct endpoint for all gifs") {
//      	expect(gifService.endpointForGifs()).to(equal("http://ham-flyingdinos.rhcloud.com/api/gifs"))
//      }
//      
//      it("should return the correct endpoint for gif search") {
//        expect(gifService.endpointForGifsFromTag("my-query")).to(equal("http://ham-flyingdinos.rhcloud.com/api/gifs?q=my-query"))
//      }
//      
//      it("should return gifs in the response") {
//        var gifsResponse = [Gif]()
//        waitUntil(timeout: 3.5) { done in
//          gifService.getGifsResponse()
//            .on(next: {
//              gifsResponse = $0.gifs
//              done()
//            })
//            .start()
//
//        }
//        expect(gifsResponse.count).to(beGreaterThan(400))
//       
//      }
//      
//      it("should return gifs for a tag search") {
//        var gifsResponse = [Gif]()
//        waitUntil { done in
//          gifService.getGifsForTagSearchResponse("no")
//            .on(next: {
//              gifsResponse = $0.gifs
//							done()
//            })
//            .start()
//        }
//        
//        expect(gifsResponse.count).to(beGreaterThan(1))
//      }
//      
//      it("should return an empty response for a bad search") {
//        var gifsResponse = [Gif]()
//        waitUntil { done in
//          gifService.getGifsForTagSearchResponse("xxxxxoko")
//            .on(next: {
//              gifsResponse = $0.gifs
//            	done()
//            })
//            .start()
//        }
//        expect(gifsResponse.count).to(equal(0))
//      }
//      
//      it("should return the thumbnail image") {
//        expect(gif.thumbnailImage).to(beNil())
//        gifService.retrieveThumbnailimageFor(gif: gif)
//          .on(next: { gif = $0 } )
//        	.start()
//        
//        expect(gif.thumbnailImage).toEventually(beTruthy(), timeout: 5)
//      }
//      
//    }
  }

}
