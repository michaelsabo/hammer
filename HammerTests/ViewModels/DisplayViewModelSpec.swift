//
//  DisplayViewModelSpec.swift
//  Hammer
//
//  Created by Mike Sabo on 11/7/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Quick
import Nimble
import ReactiveCocoa
import SwiftyJSON

class DisplayViewModelSpec: QuickSpec {
  
  override func spec() {
    
    describe("Display View Model") {
      let gif = Gif(id: "p5tJEpm", url: "http://i.imgur.com/p5tJEpm.gif", thumbnailUrl: "http://i.imgur.com/p5tJEpmb.gif", index: 0)
      let displayViewModel = DisplayViewModel(gifService: MockGifService(), tagService: MockTagService(), gif: gif)
      
      
      context("retrieving") {
        
        it("tags for gif id") {
          expect(displayViewModel.tags.value.count).to(equal(3))
        }
        
        it("image for gif id") {
          var called = false
          waitUntil { done in
            displayViewModel.gifRequestSignal
              .observeNext( { _ in
              called = true
              done()
            })
            displayViewModel.startGifImageSingal()
          }
          expect(called).to(beTrue())
        }


      }
    }
  }

}