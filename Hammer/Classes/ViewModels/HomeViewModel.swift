//
//  SearchTagViewModel.swift
//  Hammer
//
//  Created by Mike Sabo on 10/12/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import ReactiveCocoa
import GameKit

class HomeViewModel : NSObject {
	
  let title: String = "HAM"
  let cellHeight:Int = 55
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
    getGifs()
		
		tagService.getAllTags()
			.on(next: {
				response in
					if (response.tags.count > 0) {
						self.allTags.value = response.tags
					}
			})
			.start()
		
    isSearchingSignal
      .observeNext({ (searching:Bool) in
        if (!searching) {
          self.gifsForDisplay.value = self.gifCollection.value
        }
      })

	}
  
  func getGifs() {
    gifService.getGifsResponse()
      .on(next: {
        response in
        if (response.gifs.count > 0) {
          self.gifCollection.value = response.gifs
          self.gifsForDisplay.value = response.gifs
        }
      })
      .start()
  }
  
  func endSeaching() {
    self.isSearchingObserver.sendNext(false)
  }
	
	lazy var searchingTagsSignal: SignalProducer<[Tag]?, NoError> = {
		return self.searchText.producer
      .on(next: { _ in self.isSearchingObserver.sendNext(false) })
			.filter { $0.characters.count > 1 }
			.map { [weak self] (value: String) -> [Tag]? in
				self?.foundTags.value = [Tag]()
				self?.isSearchingObserver.sendNext(true)
        if let tags = self?.allTags.value as [Tag]? {
          for tag in tags {
            if ((tag.name.lowercaseString.rangeOfString(value.lowercaseString)) != nil) {
              self?.foundTags.value.append(tag)
            }
          }
        }
				return self?.foundTags.value
		}
  }()
	
	func getGifsForTagSearch() -> Void {
		gifService.getGifsForTagSearchResponse(self.searchText.value.lowercaseString)
			.on(next: {
					response in
					if (response.gifs.count > 0) {
						self.gifsForDisplay.value = response.gifs
					} else {
						self.gifsForDisplay.value = [Gif]()
					}
			}).start()
	}
  
  func tagTableViewCellHeight() -> Int {
    var tableHeight: Int
    if (self.foundTags.value.count >= 7) {
      tableHeight = cellHeight * 7
    } else {
      tableHeight = self.foundTags.value.count * cellHeight
    }
    return tableHeight;
  }
  
  func displayThumbnailForGif(indexPath indexPath: NSIndexPath, cell: ImageCell) -> ImageCell {
    if (indexPath.item < self.gifsForDisplay.value.count) {
      let gif = self.gifsForDisplay.value[indexPath.item]
      if let data = gif.thumbnailData {
        cell.imageView.image = nil
        cell.setImage(data)
        return cell
      } else {
        cell.imageView.image = UIImage()
        gifService.retrieveThumbnailImageFor(gif: gif)
          .on(next: { [weak cell] responseGif in
            cell?.setImage(responseGif.thumbnailData)
        }).start()

      }
    }
    return cell
  }
  
  func mixupGifArray() {
    let newArray = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(self.gifsForDisplay.value) as! [Gif]
    self.gifCollection.value = newArray
    self.gifsForDisplay.value = newArray
  }
}

