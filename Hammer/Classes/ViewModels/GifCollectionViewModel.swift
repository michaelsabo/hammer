//
//  GifCollectionViewModel.swift
//  Hammer
//
//  Created by Mike Sabo on 10/13/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import ReactiveCocoa

class GifCollectionViewModel {
	
	var gifCollection = MutableProperty<[Gif]>([Gif]())
	var gifsForDisplay = MutableProperty<[Gif]>([Gif]())
	
	init(gifs: [Gif]?) {
		self.gifCollection = MutableProperty<[Gif]>(gifs!)
	}
	
	

}
