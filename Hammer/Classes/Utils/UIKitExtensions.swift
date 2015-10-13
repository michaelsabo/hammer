//
//  Util.swift
//  ReactiveTwitterSearch
//
//  Created by Colin Eberhardt on 10/05/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

import UIKit
import ReactiveCocoa

struct AssociationKey {
	static var hidden: UInt8 = 1
	static var alpha: UInt8 = 2
	static var text: UInt8 = 3
}

// lazily creates a gettable associated property via the given factory
func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, key: UnsafePointer<Void>, factory: ()->T) -> T {
	return objc_getAssociatedObject(host, key) as? T ?? {
		let associatedProperty = factory()
		objc_setAssociatedObject(host, key, associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		return associatedProperty
  }()
}

func lazyMutableProperty<T>(host: AnyObject, key: UnsafePointer<Void>, setter: T -> (), getter: () -> T) -> MutableProperty<T> {
	return lazyAssociatedProperty(host, key: key) {
		let property = MutableProperty<T>(getter())
		property.producer
			.start(Event.sink(next: {
				newValue in
				setter(newValue)
			}))
		
		return property
	}
}

extension UIView {
	public var rac_alpha: MutableProperty<CGFloat> {
		return lazyMutableProperty(self, key: &AssociationKey.alpha, setter: { self.alpha = $0 }, getter: { self.alpha  })
	}
	
	public var rac_hidden: MutableProperty<Bool> {
		return lazyMutableProperty(self, key: &AssociationKey.hidden, setter: { self.hidden = $0 }, getter: { self.hidden  })
	}
}

extension UILabel {
	public var rac_text: MutableProperty<String> {
		return lazyMutableProperty(self, key: &AssociationKey.text, setter: { self.text = $0 }, getter: { self.text ?? "" })
	}
}

extension UITextField {
	public var rac_text: MutableProperty<String> {
		return lazyAssociatedProperty(self, key: &AssociationKey.text) {
			
			self.addTarget(self, action: "changed", forControlEvents: UIControlEvents.EditingChanged)
			
			let property = MutableProperty<String>(self.text ?? "")
			property.producer
				.start(Event.sink(next: {
					newValue in
					self.text = newValue
				}))
			return property
		}
	}
	
	func changed() {
		rac_text.value = self.text ?? ""
	}
}

extension UITextField {
	func rac_textSignalProducer() -> SignalProducer<String, NoError> {
		return self.rac_textSignal().asSignalProducer()
			.map({ $0 as! String })
	}
}
extension RACSignal {
	
	/// Creates a SignalProducer which will subscribe to the receiver once for
	/// each invocation of start().
	public func asSignalProducer(file: String = __FILE__, line: Int = __LINE__) -> SignalProducer<AnyObject?, NoError> {
		return SignalProducer { observer, disposable in
			let next = { (obj: AnyObject?) -> () in
				sendNext(observer, obj)
			}
			
			let error = { (nsError: NSError?) -> () in
			}
			
			let completed = {
				sendCompleted(observer)
			}
			
			let selfDisposable: RACDisposable? = self.subscribeNext(next, error: error, completed: completed)
			disposable.addDisposable(selfDisposable)
		}
	}
}
