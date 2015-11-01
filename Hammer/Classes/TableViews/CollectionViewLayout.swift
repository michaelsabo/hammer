//
//  CollectionViewLayout.swift
//  Hammer
//
//  Created by Mike Sabo on 10/23/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation

class SmallCollectionViewLayout : UICollectionViewFlowLayout {
	
	override init() {
		super.init()
		self.itemSize = CGSizeMake(100, 110)
		self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
		self.minimumInteritemSpacing = 5.0
		self.minimumLineSpacing = 2.0

	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareLayout() {
		super.prepareLayout()
	}
	
	override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
		return true
	}
}

class MediumCollectionViewLayout : UICollectionViewFlowLayout {
	
	override init() {
		super.init()
		self.itemSize = CGSizeMake(115, 125)
		self.sectionInset = UIEdgeInsetsMake(5, 8, 5, 8)
		self.minimumInteritemSpacing = 3.0
		self.minimumLineSpacing = 2.0
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareLayout() {
		super.prepareLayout()
	}
	
	override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
		return true
	}
}

class LargeCollectionViewLayout : UICollectionViewFlowLayout {
	
	override init() {
		super.init()
		self.itemSize = CGSizeMake(130, 140)
		self.sectionInset = UIEdgeInsetsMake(5, 8, 5, 8)
		self.minimumInteritemSpacing = 3.0
		self.minimumLineSpacing = 2.0
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareLayout() {
		super.prepareLayout()
	}
	
	override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
		return true
	}
}