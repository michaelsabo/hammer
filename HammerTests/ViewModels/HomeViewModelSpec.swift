//
//  HomeViewModelSpec.swift
//  Hammer
//
//  Created by Mike Sabo on 11/6/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Quick
import Nimble
import ReactiveCocoa
import SwiftyJSON

class HomeViewModelSpec: QuickSpec {
  
  override func spec() {
		
      describe("HomeViewModel") {
        let homeViewModel = HomeViewModel(searchTagService: MockTagService(), gifRetrieveService: MockGifService())

        
        context("searching for gifs") {
          let (producer, observer) = SignalProducer<String, NoError>.buffer()
          producer.start()
          homeViewModel.searchText <~ producer
          
          it("should return found tags when searching ") {
            var searching = false
            homeViewModel.isSearchingSignal.observeNext({searching = $0})
            homeViewModel.searchingTagsSignal.startWithNext({tags in
              expect(homeViewModel.foundTags.value.count).to(equal(1))
              expect(searching).to(beTrue())
              homeViewModel.endSeaching()
              expect(searching).to(beFalse())
            })
            observer.sendNext("ben")
          }
          
          it("should update the gifs being displayed when a match is found ") {
            expect(homeViewModel.gifsForDisplay.value.count).to(equal(17))
            observer.sendNext("ben")
            homeViewModel.getGifsForTagSearch()
            expect(homeViewModel.gifsForDisplay.value.count).to(equal(1))
            expect(homeViewModel.gifsForDisplay.value.first?.id).to(equal(1001))
          }
          
          it("should update the gif collection when a user is done searching ") {
            observer.sendNext("ben")
            homeViewModel.getGifsForTagSearch()
            expect(homeViewModel.gifsForDisplay.value.count).to(equal(1))
            observer.sendNext("")
            expect(homeViewModel.gifsForDisplay.value.count).to(equal(17))
          }
        }
        
        
    }
  }
  
  
    
}
