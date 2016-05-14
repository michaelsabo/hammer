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
import Result

class DisplayViewModelSpec: QuickSpec {
  
  override func spec() {
    
    describe("Display View Model") {
      let gif = Gif(id: 10, url: "http://i.imgur.com/p5tJEpm.gif", thumbnailUrl: "http://i.imgur.com/p5tJEpmb.gif", index: 0)
      let displayViewModel = DisplayViewModel(gif: gif)
      displayViewModel.gifService = MockGifService()
      displayViewModel.tagService = MockTagService()
      
      context("retrieving") {
        
        
        
        it("tags for gif id") {
          displayViewModel.startTagSignal()
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
        
        it("random alert detail should never be nil") {
          for _ in 0...100 {
            expect(displayViewModel.alertDetail).to(beTruthy())
          }
        }



      }
    }
  }

}