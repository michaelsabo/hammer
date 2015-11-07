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
	
  let title: String = "Gallery"
	let searchText = MutableProperty<String>("")
	let isSearching = MutableProperty<Bool>(false)
	
	let foundTags = MutableProperty<[Tag]>([Tag]())
	var allTags =  MutableProperty<[Tag]>([Tag]())
	
	var gifCollection = MutableProperty<[Gif]>([Gif]())
	var gifsForDisplay = MutableProperty<[Gif]>([Gif]())
	
  let isSearchingSignal: Signal<Bool, NoError>
  private let isSearchingObserver: Observer<Bool, NoError>
  
	private let tagService: TagService
	private let gifService: GifService
	
	init(searchTagService: TagService, gifRetrieveService: GifService) {
		self.tagService = searchTagService
		self.gifService = gifRetrieveService
    let (searchingSignal, searchingObserver) = Signal<Bool, NoError>.pipe()
    self.isSearchingSignal = searchingSignal
    self.isSearchingObserver = searchingObserver
		super.init()

		gifService.getGifsResponse()
			.on(next: { [unowned self]
				response in
					if (response.gifs.count > 0) {
						self.gifCollection.value = response.gifs
						self.gifsForDisplay.value = response.gifs
					}
				})
				.start()
		
		tagService.getAllTags()
			.on(next: { [unowned self]
				response in
					if (response.tags.count > 0) {
						self.allTags.value = response.tags
					}
			})
			.start()
		
    isSearchingSignal
      .observeNext({ [unowned self] (searching:Bool) in
        if (!searching) {
          self.gifsForDisplay.value = self.gifCollection.value
        }
      })
	}
  
  func userEndedSearch() {
    self.isSearchingObserver.sendNext(false)
  }
	
	lazy var searchingTagsSignal: SignalProducer<[Tag], NoError> = {
		return self.searchText.producer
      .on(next: { _ in self.isSearchingObserver.sendNext(false) })
			.filter { $0.characters.count > 1 }
			.map { [unowned self] (value: String) -> [Tag] in
				self.foundTags.value = [Tag]()
				self.isSearchingObserver.sendNext(true)
				for tag in self.allTags.value as [Tag] {
					if ((tag.text.lowercaseString.rangeOfString(value.lowercaseString)) != nil) {
						self.foundTags.value.append(tag)
					}
				}
				return self.foundTags.value
		}
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
    //TODO refactor this
    if (indexPath.item < self.gifsForDisplay.value.count) {
      cell.userInteractionEnabled = false
      cell.imageView.layer.masksToBounds = true
      let gif = self.gifsForDisplay.value[indexPath.item]
      if let image = gif.thumbnailImage {
        cell.imageView.image = nil
        cell.imageView.image = image
        cell.imageView.layer.cornerRadius = 10.0
        cell.userInteractionEnabled = true
        return cell
      } else {
        cell.imageView.image = UIImage()
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
          Gif.getThumbnailImageForGif(gif, completionHandler: { [unowned self] (responseGif, isSuccess, error) in
            cell.imageView.layer.cornerRadius = 10.0
            if (isSuccess && !self.isSearching.value) {
              if let index = self.gifsForDisplay.value.indexOf(responseGif!) {
                self.gifsForDisplay.value[index].thumbnailImage = responseGif!.thumbnailImage
                cell.imageView.image = self.gifsForDisplay.value[index].thumbnailImage
                cell.imageView.layer.cornerRadius = 10.0
                cell.hasLoaded = true
                cell.userInteractionEnabled = true
              }
            } else if (isSuccess && self.isSearching.value) {
              if let index = self.gifsForDisplay.value.indexOf(responseGif!) {
                self.gifsForDisplay.value[index].thumbnailImage = responseGif!.thumbnailImage
                cell.imageView.image = self.gifsForDisplay.value[index].thumbnailImage
                cell.imageView.layer.cornerRadius = 10.0
                cell.hasLoaded = true
                cell.userInteractionEnabled = true
              }
            } else {
              cell.userInteractionEnabled = false
            }
            })
        }
      }
    }
    return cell
  }
}

