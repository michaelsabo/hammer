//
//  HomeViewModelSpec.swift
//  Hammer
//
//  Created by Mike Sabo on 11/6/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import XCTest
import Quick
import Nimble

class HomeViewModelSpec: QuickSpec {
  
  override func spec() {

      describe("HomeViewModel") {
        var homeViewModel: HomeViewModel!
        
        beforeEach {
          homeViewModel = HomeViewModel(searchTagService: TagService(), gifRetrieveService: GifService())
          
        }
        
        it("should return gifs after being initialized") {
          expect(homeViewModel.gifsForDisplay.value.count).to(beGreaterThan(0))
        }

  
    }
  }
  
  
    
}
