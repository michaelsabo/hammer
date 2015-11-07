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
        var homeViewModel: HomeViewModel!
       
        beforeEach {
          homeViewModel = HomeViewModel(searchTagService: TagService(), gifRetrieveService: GifService())
          
        }
        
        it("should be empty ") {
          expect(homeViewModel.foundTags.value.count).to(equal(0))
        }

  
    }
  }
  
  
    
}
