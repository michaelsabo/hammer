//
//  RAC.swift
//  Hammer
//
//  Created by Mike Sabo on 10/13/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import ReactiveCocoa

struct RAC  {
	var target : NSObject!
	var keyPath : String!
	var nilValue : AnyObject!
	
	init(_ target: NSObject!, _ keyPath: String, nilValue: AnyObject? = nil) {
		self.target = target
		self.keyPath = keyPath
		self.nilValue = nilValue
	}
	
	
	func assignSignal(signal : RACSignal) {
		signal.setKeyPath(self.keyPath, onObject: self.target, nilValue: self.nilValue)
	}
}

infix operator ~> {}
func ~> (signal: RACSignal, rac: RAC) {
	rac.assignSignal(signal)
}