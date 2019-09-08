//
//  ServiceErrors.swift
//  Hammer
//
//  Created by Mike Sabo on 10/13/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

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
  /// Returns a URL request or throws if an `Error` was encountered.
  ///
  /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
  ///
  /// - returns: A URL request.
  public func asURLRequest() throws -> URLRequest {
    var urlRequest = URLRequest(url: Router.Production.appendingPathComponent(route.path))
    urlRequest.httpMethod = method.rawValue
    return try Alamofire.URLEncoding.queryString.encode(urlRequest, with: route.parameters)
  }

  static let Test = URL(string: "http://ham-flyingdinos.rhcloud.com/api")!
  static let Production = URL(string: "http://ham.life/api")!
  static let Local = URL(string: "http://localhost:9292/api/")!
	
  case gifs
  case gifsForTag(String)
  case addGif(String)
  case tags
  case tagsForGif(Int)
  case tagGifWithId(Int, String)
  
  var buildURL: URL { return Router.Production.appendingPathComponent(route.path) }
  
  var route: (path: String, parameters: Parameters?) {
    switch self {
    case .gifs: return ("/gifs", nil)
    case .gifsForTag (let tag): return ("/gifs", ["q": tag])
    case .addGif(let imgurId) : return ("/gifs", ["gif": imgurId])
    case .tags : return ("/tags", nil)
    case .tagsForGif (let gifId) : return ("/gifs/\(gifId)/tags", nil)
    case .tagGifWithId (let gifId, let tagName) : return ("/gifs/\(gifId)/tags", ["tag": tagName as AnyObject])
    }
  }
  
  var method : Alamofire.HTTPMethod  {
    switch self {
    case .tagGifWithId(_,_)  : return .post
    case .addGif(_)  : return .post
    default : return .get
    }
  }

}
