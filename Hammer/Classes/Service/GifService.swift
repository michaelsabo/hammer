//
//  GifCollectionService.swift
//  Hammer
//
//  Created by Mike Sabo on 10/13/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import Regift

class GifService {
	
	func getGifsResponse(completion: @escaping (_ success: Bool, _ gifs:Gifs?) -> Void) {
      Alamofire.request(Router.gifs)
        .responseJSON { response in
          if let json = response.result.value {
            let gifs = Gifs(gifsJSON: JSON(json))
            if (response.result.isSuccess) {
              completion(true, gifs)
            }
          }
          completion(false, nil)
		}
	}
	
	func getGifsForTagSearchResponse(_ query: String, completion: @escaping (_ success: Bool, _ gifs:Gifs?) -> Void) {
			Alamofire.request(Router.gifsForTag(query))
				.responseJSON { response in
					if let json = response.result.value {
						let gifs = Gifs(gifsJSON: JSON(json))
						if (response.result.isSuccess) {
              completion(true, gifs)
            }
          }
          completion(false, nil)
			}
	}
	
	func retrieveThumbnailImageFor(_ gif: Gif, completion: @escaping (_ success: Bool, _ gif:Gif?) -> Void) {
			Alamofire.request(gif.thumbnailUrl, method: .get)
				.responseData { response in
					if (response.result.isSuccess) {
						if let data = response.result.value {
              gif.thumbnailData = data
              completion(true, gif)
            }
          }
          completion(false, nil)
			}
		}
	
	func retrieveImageDataFor(_ gif: Gif, completion: @escaping (_ success: Bool, _ data:Data?) -> Void) {
    Alamofire.request(gif.url, method: .get)
				.responseData { response in
					if (response.result.isSuccess) {
						if let data = response.result.value {
              completion(true, data)
            }
          }
          completion(false, nil)
		}
	}
  
  func retrieveGifForVideo(_ gif: Gif, completion: @escaping (_ success: Bool, _ data:Data?, _ byteSize:Int) -> Void) {
    DispatchQueue.global().async {
      Regift.createGIFFromSource(URL(safeString: gif.videoUrl)) { result,size in
        if let filePath = result {
          if let data = try? Data(contentsOf: filePath) {
            completion(true, data, size)
          }
        }
       completion(false, nil, 0)
      }
    }
  }
  
  func addGif(_ id : String, completion: @escaping (_ success: Bool) -> Void) {
      Alamofire.request(Router.addGif(id))
        .responseJSON { response in
          if (response.result.isSuccess) {
//            let json = JSON(response.result.value!)
//            let gif = Gif(json: json["gif"], index: 0)
            completion(true)
          }
          completion(false)
      }
  }
}


	


extension String {
	
	mutating func replaceSpaces() -> String {
		return self.replacingOccurrences(of: " ", with: "-")
	}
	
}
