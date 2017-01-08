//
//  TagAutocompleteService.swift
//  Hammer
//
//  Created by Mike Sabo on 10/12/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//


import Alamofire
import SwiftyJSON

class TagService {

  func tagGifWith(_ id : Int, tag: String, completion: @escaping (_ success: Bool, _ tag:Tag?) -> Void) {
    Alamofire.request(Router.tagGifWithId(id, tag))
      .responseJSON { response in
        if (response.result.isSuccess) {
          let json = JSON(response.result.value!)
          let tag = Tag(json: json["tag"])
          completion(true, tag)
        }
      completion(false, nil)
		}
	}

  func getAllTags(completion: @escaping (_ success: Bool, _ tags:TagsResponse?) -> Void) {
    Alamofire.request(Router.tags)
      .responseJSON { response in
        if (response.result.isSuccess) {
          let tags = TagsResponse(json: JSON(response.result.value!))
          completion(true, tags)
        }
        completion(false, nil)
    }
  }
	
	func getTagsForGifId(_ id: Int, completion: @escaping (_ success: Bool, _ tags:TagsResponse?) -> Void) {
    Alamofire.request(Router.tagsForGif(id))
      .responseJSON { response in
        if (response.result.isSuccess) {
          let tags = TagsResponse(json: JSON(response.result.value!))
          completion(true, tags)
        }
        completion(false, nil)
		}
	}
	
}
