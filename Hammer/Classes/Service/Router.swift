//
//  ServiceErrors.swift
//  Hammer
//
//  Created by Mike Sabo on 10/13/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import Alamofire

enum ServiceError: Int {
	case accessDenied = 0,
	invalidRequest,
	badRequest,
	notFound,
	noError
	
	func toError() -> NSError {
		return NSError(domain:"Ham", code: self.rawValue, userInfo: nil)
	}
}

enum ServiceResponse: Int {
	case success = 0,
	failure
}

enum Router: URLRequestConvertible {
  static let Test = Foundation.URL(string: "http://ham-flyingdinos.rhcloud.com/api")!
  static let Production = Foundation.URL(string: "http://52.2.139.235/api")!
  static let Local = Foundation.URL(string: "http://localhost:9292/api/")!
	
  case gifs
  case gifsForTag(String)
  case addGif(String)
  case tags
  case tagsForGif(Int)
  case tagGifWithId(Int, String)
  
  var URL: Foundation.URL { return Router.Production.appendingPathComponent(route.path) }
  
  var route: (path: String, parameters: [String : AnyObject]?) {
    switch self {
    case .gifs: return ("/gifs", nil)
    case .gifsForTag (let tag): return ("/gifs", ["q": tag as AnyObject])
    case .addGif(let imgurId) : return ("/gifs", ["gif": imgurId as AnyObject])
    case .tags : return ("/tags", nil)
    case .tagsForGif (let gifId) : return ("/gifs/\(gifId)/tags", nil)
    case .tagGifWithId (let gifId, let tagName) : return ("/gifs/\(gifId)/tags", ["tag": tagName as AnyObject])
    }
  }
  
  var method : Alamofire.Method  {
    switch self {
    case .tagGifWithId(_,_)  : return .POST
    case .addGif(_)  : return .POST
    default : return .GET
    }
  }
  
  var URLRequest: NSMutableURLRequest {
    let mutableURLRequest = NSMutableURLRequest(url: URL)
    mutableURLRequest.HTTPMethod = method.rawValue
    return Alamofire
      .ParameterEncoding
      .URL
      .encode(mutableURLRequest, parameters: (route.parameters ?? [ : ])).0
  }

}
