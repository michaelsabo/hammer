//
//  SearchTagViewModel.swift
//  Hammer
//
//  Created by Mike Sabo on 10/12/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import ReactiveCocoa

class HomeViewModel : NSObject {
	
	let searchText = MutableProperty<String>("")
	let isSearching = MutableProperty<Bool>(false)
	
	let foundTags = MutableProperty<[Tag]>([Tag]())
	var allTags =  MutableProperty<[Tag]>([Tag]())
	
	var gifCollection = MutableProperty<[Gif]>([Gif]())
	var gifsForDisplay = MutableProperty<[Gif]>([Gif]())
	
	private let tagService: TagService
	private let gifService: GifService
	
	init(searchTagService: TagService, gifRetrieveService: GifService) {
		self.tagService = searchTagService
		self.gifService = gifRetrieveService
		super.init()
		gifService.getGifsResponse()
			.on(next: {
				response in
					if (response.gifs.count > 0) {
						self.gifCollection.value = response.gifs
						self.gifsForDisplay.value = response.gifs
					}
				})
				.start()
		
		tagService.getAllTags()
			.on(next: {
				response in
					if (response.tags.count > 0) {
						self.allTags.value = response.tags
					}
			})
			.start()
		
		isSearching.producer
			.start( {
				if ($0.value == false) {
					self.gifsForDisplay.value = self.gifCollection.value
				}
			})
	}
	
	lazy var searchingTagsSignal: SignalProducer<[Tag], NoError> = {
		return self.searchText.producer
			.filter { $0.characters.count > 1 }
			.map { (value: String) -> [Tag] in
				var matches = [Tag]()
				self.foundTags.value = [Tag]()
				self.isSearching.value = true
				for tag in self.allTags.value as [Tag] {
					if ((tag.text.lowercaseString.rangeOfString(value.lowercaseString)) != nil) {
						self.foundTags.value.append(tag)
					}
				}
				return matches
		}
		}()
	
	lazy var tableWillHide: AnyProperty<Bool> = {
		let property = MutableProperty(false)
		property <~ self.searchText.producer
			.map {
				return !(($0.characters.count > 1) && self.isSearching.value)
		}
		return AnyProperty(property)
		}()
	
	func getGifsForTagSearch() -> Void {
		gifService.getGifsForTagSearchResponse(self.searchText.value.replaceSpaces())
			.on(next: {
					response in
					if (response.gifs.count > 0) {
						self.gifsForDisplay.value = response.gifs
					} else {
						self.gifsForDisplay.value = [Gif]()
					}
			}).start()
	}

  func displayCellForGifs(indexPath indexPath: NSIndexPath, cell: ImageCell) -> ImageCell {
    if (indexPath.item < self.gifsForDisplay.value.count) {
      cell.imageView.layer.masksToBounds = true
      let gif = self.gifsForDisplay.value[indexPath.item]
      cell.userInteractionEnabled = true
      let imageProducer = NSURLSession.sharedSession().rac_dataWithRequest(NSURLRequest(URL: NSURL(string: gif.thumbnailUrl)!))
        .map({[weak gif = gif] data, _ in
            if let image = UIImage(data: data) {
              gif?.thumbnailData = data
              gif?.thumbnailImage = image
              return image
            }
            return UIImage()
        })
        .flatMapError {_ in SignalProducer<UIImage, NoError>(value: UIImage()) }
      
      let prepForReuse = cell.rac_prepareForReuseSignal.toSignalProducer()
        .map {_ in () }
        .flatMapError {_ in SignalProducer<(), NoError>.empty }
      
      let imageUntilReuse = imageProducer
        .takeUntil(prepForReuse)
        .observeOn(UIScheduler())
      
      let nilThenImageUntilReuse = SignalProducer<AnyObject?, NoError>(value: nil)
        .concat(imageUntilReuse .map { $0 as AnyObject? })
      
      DynamicProperty(object: cell.imageView, keyPath: "image") <~ nilThenImageUntilReuse
    }
    return cell
  }

	
	
	
}

