//
//  SearchTagViewModel.swift
//  Hammer
//
//  Created by Mike Sabo on 10/12/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import RxSwift
import GameKit


class HomeViewModel : NSObject {
	
  let title: String = "HAM"
  let cellHeight:Int = 55
	let searchText = Variable<String>("")
	let isSearching = Variable<Bool>(false)
	
	let foundTags = Variable<[Tag]>([Tag]())
	var allTags =  Variable<[Tag]>([Tag]())
	
	var gifCollection = Variable<[Gif]>([Gif]())
	var gifsForDisplay = Variable<[Gif]>([Gif]())
	
  let isSearchingSignal = Variable(false)
  
	fileprivate let tagService: TagService
	fileprivate let gifService: GifService
	
  var disposeBag:DisposeBag! = DisposeBag()
  
	init(searchTagService: TagService, gifRetrieveService: GifService) {
		self.tagService = searchTagService
		self.gifService = gifRetrieveService
    
		super.init()
    getGifs()
		
    tagService.getAllTags(completion: { success,response in
      if success {
        if let tags = response?.tags {
          self.allTags.value = tags
        }
      }
    })
			
		
    isSearchingSignal.asObservable()
      .subscribe(onNext: { searching in
        if (!searching) {
          self.gifsForDisplay.value = self.gifCollection.value
        }
      }).addDisposableTo(disposeBag)

	}
  
  func getGifs() {
    gifService.getGifsResponse(completion: { success,response in
      if let gifs = response?.gifs {
        if gifs.count > 0 {
          self.gifCollection.value = gifs
          self.gifsForDisplay.value = self.gifCollection.value
        }
      }
    })
  }
  
  func endSeaching() {
    isSearchingSignal.value = false
  }
	
	func searchingTagsSignal() -> Observable<[Tag]?> {
//    return Observable.create { o in
//      return Disposables.create {
//        print("Disposed")
//      }
//    }
//    return Observable.create { observer -> Disposable in
      return self.searchText.asObservable()
//      .flatMap { val in self.isSearchingSignal.value = false; return val }
			.filter { $0.characters.count > 1 }
			.map({ [weak self] (value: String) -> [Tag]? in
				self?.foundTags.value = [Tag]()
				self?.isSearchingSignal.value = true
        if let tags = self?.allTags.value as [Tag]? {
          for tag in tags {
            if ((tag.name.lowercased().range(of: value.lowercased())) != nil) {
              self?.foundTags.value.append(tag)
            }
          }
        }
        return self?.foundTags.value
      })
  }
	
	func getGifsForTagSearch() {
    gifService.getGifsForTagSearchResponse(self.searchText.value.lowercased(), completion: { success,response in
      if let gifs = response?.gifs {
        if gifs.count > 0 {
          self.gifsForDisplay.value = gifs
        } else {
          self.gifsForDisplay.value = []
        }
      }
    })
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
  
  func displayThumbnailForGif(_ indexPath: IndexPath, cell: ImageCell) -> ImageCell {
    if (indexPath.item < self.gifsForDisplay.value.count) {
      let gif = self.gifsForDisplay.value[indexPath.item]
      if let data = gif.thumbnailData {
        cell.imageView.image = nil
        cell.setImage(data)
        return cell
      } else {
        cell.imageView.image = UIImage()
        gifService.retrieveThumbnailImageFor(gif, completion: { [weak cell] success,responseGif in
          if success {
            if let gif = responseGif {
              cell?.setImage(gif.thumbnailData)
            }
          }
        })
      }
    }
    return cell
  }
  
  func resetAnimationFlag() {
    for g in self.gifCollection.value {
      g.showAnimation = true
    }
  }
  
  func mixupGifArray() {
    resetAnimationFlag()
    let newArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self.gifsForDisplay.value) as! [Gif]
    self.gifsForDisplay.value = newArray
  }
}

