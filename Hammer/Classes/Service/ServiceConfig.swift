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
	case AccessDenied = 0,
	InvalidRequest,
	BadRequest,
	NotFound,
	NoError
	
	func toError() -> NSError {
		return NSError(domain:"Ham", code: self.rawValue, userInfo: nil)
	}
}

enum ServiceResponse: Int {
	case Success = 0,
	Failure
}

enum Router: URLRequestConvertible {
  static let Test = NSURL(string: "http://ham-flyingdinos.rhcloud.com/api")!
  static let Production = NSURL(string: "http://52.2.139.235/api")!
  static let Local = NSURL(string: "http://localhost:9292/api/")!
	
  case Gifs
  case GifsForTag(String)
  case Tags
  case TagsForGif(Int)
  
  var URL: NSURL { return Router.Production.URLByAppendingPathComponent(route.path) }
  
  var route: (path: String, parameters: [String : AnyObject]?) {
    switch self {
    case .Gifs: return ("/gifs", nil)
    case .GifsForTag (let tag): return ("/gifs", ["q": tag])
    case .Tags : return ("/tags", nil)
    case .TagsForGif (let gifId) : return ("/gifs/\(gifId)/tags", nil)
    }
  }
  
  var URLRequest: NSMutableURLRequest {
    return Alamofire
      .ParameterEncoding
      .URL
      .encode(NSURLRequest(URL: URL), parameters: (route.parameters ?? [ : ])).0
  }

}
