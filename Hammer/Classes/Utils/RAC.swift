//
//  RACSignal+Extensions.swift
//  swift-mvvm-examples
//
//  Created by Kyle LeNeau on 1/11/15.
//  Copyright (c) 2015 Kyle LeNeau. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

extension UITextField {
	
	func rac_textSignalProducer() -> SignalProducer<String, NoError> {
		return self.rac_textSignal().asSignalProducer()
			.map({ $0 as! String })
	}
}

extension RACSignal {
	
	/// Creates a SignalProducer which will subscribe to the receiver once for
	/// each invocation of start().
	public func asSignalProducer(_ file: String = #file, line: Int = #line) -> SignalProducer<AnyObject?, NoError> {
		return SignalProducer { observer, disposable in
			let next = { (obj: AnyObject?) -> () in
				observer.sendNext(obj)
			}
			
			let error = { (nsError: NSError?) -> () in
			}
			
			let completed = {
				observer.sendCompleted()
			}
			
			let selfDisposable: RACDisposable? = self.subscribeNext(next, error: error, completed: completed)
			disposable.addDisposable(selfDisposable)
		}
	}
}

extension RACSignal {
	
	func subscribeNextAs<T>(_ nextClosure:@escaping (T) -> ()) ->() {
		self.subscribeNext { (next: AnyObject!) -> () in
			let nextAsT = next as! T
			nextClosure(nextAsT)
		}
	}
	
	func subscribeNextAs<T>(_ nextClosure:@escaping (T) -> (), completed: () -> ()) ->() {
		self.subscribeNext({ (next: AnyObject!) -> () in
			let nextAsT = next as! T
			nextClosure(nextAsT)
			}, completed: completed)
	}
	
	func subscribeNextAs<T>(_ nextClosure:@escaping (T) -> (), error:@escaping (NSError) -> (), completed: () -> ()) ->() {
		self.subscribeNext({ (next: AnyObject!) -> () in
			let nextAsT = next as! T
			nextClosure(nextAsT)
			}, error: { (err: NSError!) -> Void in
				error(err)
			}, completed: completed)
	}
	
	func subscribeNextAs<T>(_ nextClosure:@escaping (T) -> (), error:@escaping (NSError) -> ()) ->() {
		self.subscribeNext({ (next: AnyObject!) -> () in
			let nextAsT = next as! T
			nextClosure(nextAsT)
			}, error: { (err: NSError!) -> Void in
				error(err)
		})
	}
	
	func flattenMapAs<T: AnyObject>(_ flattenMapClosure:(T) -> RACSignal) -> RACSignal {
		return self.flattenMap { (next: AnyObject!) -> RACStream! in
			let nextAsT = next as! T
			return flattenMapClosure(nextAsT)
		}
	}
	
	func mapAs<T: AnyObject, U: AnyObject>(_ mapClosure:@escaping (T) -> U) -> RACSignal {
		return self.map { (next: AnyObject!) -> AnyObject! in
			let nextAsT = next as! T
			return mapClosure(nextAsT)
		}
	}
	
	func filterAs<T: AnyObject>(_ filterClosure:@escaping (T) -> Bool) -> RACSignal {
		return self.filter { (next: AnyObject!) -> Bool in
			let nextAsT = next as! T
			return filterClosure(nextAsT)
		}
	}
	
	func doNextAs<T: AnyObject>(_ nextClosure:@escaping (T) -> ()) -> RACSignal {
		return self.doNext { (next: AnyObject!) -> () in
			let nextAsT = next as! T
			nextClosure(nextAsT)
		}
	}
}

// So I expect the ReactiveCocoa fellows to figure out a replacement API for the RAC macro.
// Currently, I don't see one there, so we'll use this solution until an official one exists.

// Pulled from http://www.scottlogic.com/blog/2014/07/24/mvvm-reactivecocoa-swift.html

public struct RAC {
	var target : NSObject!
	var keyPath : String!
	var nilValue : AnyObject!
	
	init(_ target: NSObject!, _ keyPath: String, nilValue: AnyObject? = nil) {
		self.target = target
		self.keyPath = keyPath
		self.nilValue = nilValue
	}
	
	func assignSignal(_ signal : RACSignal) -> RACDisposable {
		return signal.setKeyPath(self.keyPath, onObject: self.target, nilValue: self.nilValue)
	}
}

infix operator <~ {
associativity right
precedence 90
}

public func <~ <E>(rac: RAC, producer: SignalProducer<String, E>) -> RACDisposable {
	let signal = producer.map({ $0 as AnyObject? }).toRACSignal()
	return rac.assignSignal(signal)
}

public func <~ <E>(rac: RAC, producer: SignalProducer<Bool, E>) -> RACDisposable {
	let signal = producer.map({ $0 as AnyObject? }).toRACSignal()
	return rac.assignSignal(signal)
}

public func <~ <E>(rac: RAC, producer: SignalProducer<UIImage, E>) -> RACDisposable {
	let signal = producer.map({ $0 as AnyObject? }).toRACSignal()
	return rac.assignSignal(signal)
}

public func <~ (rac: RAC, signal: RACSignal) -> RACDisposable {
	return signal ~> rac
}

public func ~> (signal: RACSignal, rac: RAC) -> RACDisposable {
	return rac.assignSignal(signal)
}

func RACObserve(_ target: NSObject!, keyPath: String) -> RACSignal  {
	return target.rac_valuesForKeyPath(keyPath, observer: target)
}


