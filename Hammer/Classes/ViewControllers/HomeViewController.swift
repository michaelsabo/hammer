//
//  HomeViewController.swift
//  Hammer
//
//  Created by Mike Sabo on 10/4/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import SwiftyJSON
import ChameleonFramework
import NVActivityIndicatorView
import Font_Awesome_Swift
import MMPopupView
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout {
	
  @IBOutlet weak var viewCollection:UICollectionView!
  var tagSearch:UITextField!
	var autocompleteTableView:UITableView = UITableView()
  var searchView:UIView!
	
	let kCustomRows = 8
	let kImageCell = "ImageCell"
	var refreshControl = UIRefreshControl()
  
	let homeViewModel: HomeViewModel = {
		return HomeViewModel(searchTagService: TagService(), gifRetrieveService: GifService())
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = self.homeViewModel.title
    let settingsIcon = UIBarButtonItem().setup(target: self, icon: .FAGear, action: #selector(HomeViewController.showSettings))
    let searchIcon = UIBarButtonItem().setup(target: self, icon: .FASearch, action: #selector(HomeViewController.updateSearchViews))
    navigationItem.leftBarButtonItem = settingsIcon
    navigationItem.rightBarButtonItem = searchIcon
		setupViews()
		setupBindings()
	}
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.view.backgroundColor = ColorThemes.getBackgroundColor()
    self.configureNavigationBar()
    self.viewCollection.backgroundColor = ColorThemes.getBackgroundColor()
    showUpdateAlert()
  }
  var disposeBag:DisposeBag! = DisposeBag()
	func setupBindings() {
		tagSearch.delegate = self
		_ = tagSearch.rx.textInput <-> self.homeViewModel.searchText
    
    
//    RAC(self.autocompleteTableView, "hidden") <~ SignalProducer(signal: self.homeViewModel.isSearchingSignal.map({!$0}))

		self.homeViewModel.gifsForDisplay.asObservable()
      .subscribe(onNext: { _ in
        self.isScrollingDown = false
        self.viewCollection.reloadData()
        self.refreshControl.endRefreshing()
      }).addDisposableTo(disposeBag)
    
		_ = self.homeViewModel.searchingTagsSignal().asObservable()
      .subscribe(onNext: { _ in
        self.adjustHeightOfTableView()
        self.autocompleteTableView.reloadData()
      })

	}
	
	func setupViews() {
    self.viewCollection.register(UINib.init(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
		let tableViewframe = CGRect(x: 0, y: 110, width: Screen.screenWidth-20, height: 300)
		autocompleteTableView = SearchGifsTableView(frame: tableViewframe, style: UITableViewStyle.plain)
		autocompleteTableView.delegate = self
		autocompleteTableView.dataSource = self
    view.addSubview(autocompleteTableView)
    self.viewCollection.setCollectionViewLayout()
    searchView = UIView.init(frame: CGRect(x: 0, y: 67, width: Screen.screenWidth, height: 90))
    searchView.defaultProperties()
    self.view.addSubview(searchView)
    tagSearch = UITextField.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width-20, height: 60))
    tagSearch.createSearchTextField(placeholder: "Whatya looking for?")
    self.searchView.addSubview(tagSearch)
    addAutoLayoutConstraints()
    refreshControl.addTarget(self, action: #selector(HomeViewController.refreshImages), for: UIControlEvents.valueChanged)
    viewCollection.addSubview(refreshControl)
	}
  
  func addAutoLayoutConstraints() {
    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
    
    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90))
    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Screen.screenWidth))
    
    self.searchView.addConstraint(NSLayoutConstraint(item: tagSearch, attribute: .left, relatedBy: .equal, toItem: searchView, attribute: .left, multiplier: 1, constant: 10))
    self.searchView.addConstraint(NSLayoutConstraint(item: searchView, attribute: .right, relatedBy: .equal, toItem: tagSearch, attribute: .right, multiplier: 1, constant: 10))
    self.searchView.addConstraint(NSLayoutConstraint(item: tagSearch, attribute: .top, relatedBy: .equal, toItem: searchView, attribute: .top, multiplier: 1, constant: 10))
    self.searchView.addConstraint(NSLayoutConstraint(item: tagSearch, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60))
    
    self.view.addConstraint(NSLayoutConstraint(item: autocompleteTableView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 10))
    self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .right, relatedBy: .equal, toItem: autocompleteTableView, attribute: .right, multiplier: 1, constant: 10))
    self.view.addConstraint(NSLayoutConstraint(item: autocompleteTableView, attribute: .top, relatedBy: .equal, toItem: tagSearch, attribute: .bottom, multiplier: 1, constant: 0))
  }
  
  func refreshImages() {
    self.homeViewModel.getGifs()
  }
	
	// MARK: UICollectionView Data Methods
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
			return self.homeViewModel.gifsForDisplay.value.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
		return self.homeViewModel.displayThumbnailForGif(indexPath, cell: cell)
	}
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let cell = cell as! ImageCell
    guard cell.hasLoaded else {
      return
    }
    let gif = self.homeViewModel.gifsForDisplay.value[indexPath.item]
    if (gif.showAnimation && isScrollingDown) {
      
      switch indexPath.item % 3 {
      case 0:
        cell.animateFromLeft {
          self.homeViewModel.gifsForDisplay.value[indexPath.item].showAnimation = false
        }
        break
      case 1:
        cell.scaleToFullSize {
          self.homeViewModel.gifsForDisplay.value[indexPath.item].showAnimation = false
        }
        break
      case 2:
        cell.animateFromRight {
          self.homeViewModel.gifsForDisplay.value[indexPath.item].showAnimation = false
        }
        break
      default:
        break
        
      }
      
    }
    self.homeViewModel.gifsForDisplay.value[indexPath.item].showAnimation = false
  }

	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let displayViewController = DisplayViewController(nibName: "DisplayViewController", bundle: Bundle.main)
    let gif = self.homeViewModel.gifsForDisplay.value[indexPath.item]
    if (gif.thumbnailData != nil) {
      displayViewController.displayGifViewModel = DisplayViewModel(gif: gif)
      navigationController?.pushViewController(displayViewController, animated: true)
    }
	}
	
  var lastContentOffset:CGFloat = 0.0
  var isScrollingDown = true
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (self.homeViewModel.foundTags.value.count < 1 && !searchView.isHidden) {
      updateSearchViews()
    }
    if (lastContentOffset > scrollView.contentOffset.y) {
      isScrollingDown = false
    } else {
      isScrollingDown = true
    }
    lastContentOffset = scrollView.contentOffset.y;
	}
  
  func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    viewCollection.reloadItems(at: viewCollection.indexPathsForVisibleItems)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    viewCollection.reloadItems(at: viewCollection.indexPathsForVisibleItems)
  }
	
	// MARK: UITableView Data Methods
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.homeViewModel.foundTags.value.count
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func adjustHeightOfTableView() {
		autocompleteTableView.frame = CGRect(x: autocompleteTableView.frame.origin.x, y: autocompleteTableView.frame.origin.y, width: CGFloat(autocompleteTableView.frame.size.width), height: CGFloat(self.homeViewModel.tagTableViewCellHeight()));
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "AutocompleteResultCell"
		var cell = autocompleteTableView.dequeueReusableCell(withIdentifier: cellIdentifier) as UITableViewCell!
		if (cell == nil) {
			cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
		}
		if (self.homeViewModel.foundTags.value.count-1 >= indexPath.row) {
			cell?.textLabel?.text = self.homeViewModel.foundTags.value[indexPath.row].name.uppercased()
		}
    cell?.defaultAutocompleteProperties()
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.tagSearch.text = self.homeViewModel.foundTags.value[indexPath.row].name
    self.homeViewModel.searchText.value = self.homeViewModel.foundTags.value[indexPath.row].name
		autocompleteTableView.deselectRow(at: indexPath, animated: true)
		textFieldShouldReturn(self.tagSearch)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return CGFloat(self.homeViewModel.cellHeight)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    updateSearchViews()
    self.viewCollection.superview?.bringSubview(toFront: viewCollection)
	}
	
	// MARK: UI Text Field Delegates
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    updateSearchViews()
    self.viewCollection.superview?.bringSubview(toFront: viewCollection)
    self.homeViewModel.getGifsForTagSearch()
		return true
	}
	
	func textFieldShouldClear(_ textField: UITextField) -> Bool {
    self.homeViewModel.searchText.value = ""
		return true
	}
  
  func showSettings() {
    let settingsController = SettingsViewController(nibName: "Settings", bundle: Bundle.main)
    let navController = UINavigationController.init(rootViewController: settingsController)
    self.present(navController, animated: true, completion: nil)
  }
  
  func showUpdateAlert() {
    if (UserDefaults.showUpdateAlert) {
      let alertConfig = MMAlertViewConfig.global()
      alertConfig?.defaultConfig()
      alertConfig?.defaultTextOK = "OK"
      let detailText = " - New Dark Theme in Settings \n - Shake Device to Randomize Gifs \n - Favorites and Keyboard Coming Soon!"
      let alertView = MMAlertView.init(confirmTitle: "Update", detail:detailText)
      alertView?.showCompletionBlock = { _, finished in
        UserDefaults.showUpdateAlert = false
      }
      alertView?.show()
    }
  }
  
  func updateSearchViews() {
    var shouldHide:Bool = true
    if (searchView.isHidden) {
      shouldHide = false
      addBlurEffect()
      searchView.superview?.bringSubview(toFront: searchView)
      autocompleteTableView.superview?.bringSubview(toFront: autocompleteTableView)
      tagSearch.becomeFirstResponder()
    } else {
      removeBlurView()
      view.endEditing(true)
      self.homeViewModel.endSeaching()
    }
    tagSearch.isHidden = shouldHide
    searchView.isHidden = shouldHide
  }
  
  func addBlurEffect() {
    let blurStyle = UserDefaults.darkThemeEnabled ? UIBlurEffectStyle.dark : UIBlurEffectStyle.light
    let blurEffect = UIBlurEffect(style: blurStyle)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    blurEffectView.tag = 8888
    view.addSubview(blurEffectView)
  }
  
  func removeBlurView() {
    for subview in self.view.subviews {
      if (subview.tag == 8888) {
        subview.removeFromSuperview()
      }
    }
  }
  
  // MARK: shake delegates
  
  override var canBecomeFirstResponder : Bool {
    return true
  }
  
  override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      self.homeViewModel.mixupGifArray()
    }
  }

	
}
