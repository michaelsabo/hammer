//
//  ServiceErrors.swift
//  Hammer
//
//  Created by Mike Sabo on 10/13/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit

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

enum Request: String {
	case Production = "http://ham-flyingdinos.rhcloud.com/api/",
	Local = "http://localhost:9292/api/"
	
	static func forEndpoint(endpoint: String) -> String {
			return Production.rawValue + endpoint
	}
}
