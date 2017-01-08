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
		self.itemSize = CGSize(width: 100, height: 110)
		self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
		self.minimumInteritemSpacing = 5.0
		self.minimumLineSpacing = 2.0

	}

	required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
	}
	
	override func prepare() {
		super.prepare()
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
}

class MediumCollectionViewLayout : UICollectionViewFlowLayout {
	
	override init() {
		super.init()
		self.itemSize = CGSize(width: 115, height: 125)
		self.sectionInset = UIEdgeInsetsMake(5, 8, 5, 8)
		self.minimumInteritemSpacing = 2.0
		self.minimumLineSpacing = 2.0
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepare() {
		super.prepare()
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
}

class LargeCollectionViewLayout : UICollectionViewFlowLayout {
	
	override init() {
		super.init()
		self.itemSize = CGSize(width: 130, height: 140)
		self.sectionInset = UIEdgeInsetsMake(5, 8, 5, 8)
		self.minimumInteritemSpacing = 3.0
		self.minimumLineSpacing = 2.0
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepare() {
		super.prepare()
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
}

extension UICollectionView {
  
  func setCollectionViewLayout() {
    if (Screen.screenWidth > 400) {
      self.collectionViewLayout = LargeCollectionViewLayout.init()
    } else if (Screen.screenWidth > 350) {
      self.collectionViewLayout = MediumCollectionViewLayout.init()
    } else {
      self.collectionViewLayout = SmallCollectionViewLayout.init()
    }
  }
  
}
