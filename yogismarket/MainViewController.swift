//
//  MainViewController.swift
//  yogismarket
//
//  Created by kiler on 28/01/2020.
//  Copyright © 2020 kiler. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMobileAds


class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    

    
   
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var itemsCollectionView: UICollectionView!

    var adLoader: GADAdLoader!
//    var nativeAd: GADUnifiedNativeAd!
    var nativeAdView: GADUnifiedNativeAdView!
    var heightConstraint : NSLayoutConstraint?
//    var nativeAds = [GADUnifiedNativeAd]()
    
    
    
    var itemList : [Any] = []
    var filteredItemList : [Item] = []
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
             return searchController.searchBar.text?.isEmpty ?? true
           }
           
    var isFiltering: Bool {
             return searchController.isActive && !isSearchBarEmpty
           }
    
    var isCategorySelected = false
    
    var itemName = ""
    
//    struct Model {
//        var index: Int
//        var price: String
//        var title: String
//        var isBig: Bool
//    }

    struct Categories {
        var name: String
        var image: UIImage

    }
    

    private let catSet = [Categories(name: "All", image: UIImage(systemName: "globe")!),
                        Categories(name: "Mats", image: UIImage(systemName: "rectangle")!),
                          Categories(name: "Pants", image: UIImage(systemName: "sun.max")!),
                          Categories(name: "Tops", image: UIImage(systemName: "flame")!),
                          Categories(name: "Bags", image: UIImage(systemName: "bag")!),
                          Categories(name: "Accessories", image: UIImage(systemName: "cart")!),
                          Categories(name: "Books", image: UIImage(systemName: "book")!)
                          
        ]
    
//    public func adLoader(_ adLoader: GADAdLoader,
//    didReceive nativeAd: GADUnifiedNativeAd)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = itemsCollectionView?.collectionViewLayout as? CustomLayout {
          layout.delegate = self
        }

        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = 1
        
        let adMediaOrientation = GADNativeAdMediaAdLoaderOptions()
        adMediaOrientation.mediaAspectRatio = .portrait
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "kGADSimulatorID" ]
        
        
        //admob produkcja ca-app-pub-8857410705016797/1542402291
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: self,
            adTypes: [GADAdLoaderAdType.unifiedNative],
            options: [multipleAdsOptions, adMediaOrientation])
        adLoader.delegate = self
        adLoader.load(GADRequest())


        
//        guard let nibObjects = Bundle.main.loadNibNamed("NativeAdView", owner: nil, options: nil),
//          let adView = nibObjects.first as? GADUnifiedNativeAdView else {
//            assert(false, "Could not load nib file for adView")
//        }
//        setAdView(adView)
        
        
        
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        
        itemsCollectionView.register(UINib(nibName: "NativeAdViewCell", bundle: nil), forCellWithReuseIdentifier: "NativeAdViewCell")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search yogismarket"
        searchController.hidesNavigationBarDuringPresentation = false
//        navigationItem.title = "Yogis Market"
        
        navigationItem.titleView = searchController.searchBar
//        searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal
//        navigationItem.searchController = searchController
        definesPresentationContext = true

       
        
        
        
        FirebaseManager.sharedInstance.getItems() { (items) in
            
            self.itemList = items
            self.itemsCollectionView.reloadData()
            
//            print("PJ \(itemList)")
            
            
        }
        
        
        
    }

    
    func setAdView(_ view: GADUnifiedNativeAdView) {
      // Remove the previous ad view.
      nativeAdView = view
//      nativeAdPlaceholder.addSubview(nativeAdView)
      nativeAdView.translatesAutoresizingMaskIntoConstraints = false

      // Layout constraints for positioning the native ad view to stretch the entire width and height
      // of the nativeAdPlaceholder.
      let viewDictionary = ["_nativeAdView": nativeAdView!]
      self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                              options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
      self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                              options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
    }
    
    


   
    
    
    
    func filterContentForSearchText(_ searchText: String,
                                    category: Item.Category? = nil) {
        
        
      filteredItemList = itemList.filter { (item: Any) -> Bool in
        return (item as! Item).category.lowercased().contains(searchText.lowercased())
        } as! [Item]
//        print("PJ w filtercontentforserachtext, cat = \(searchText), filtered.count = \(filteredItemList.count)")
      itemsCollectionView.reloadData()
    }
    

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.categoryCollectionView{
            return catSet.count
        } else {
            if (isFiltering || isCategorySelected) {
              return filteredItemList.count
            }
            return itemList.count

        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.categoryCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
//            cell.backgroundColor = self.randomColor()
//            print("PJ tag: \(cell.tag)")
            cell.categoryName.text = catSet[indexPath.row].name
            cell.image.image = catSet[indexPath.row].image
            
            return cell
            
        } else {
           
            if let cellItem = itemList[indexPath.row] as? Item {
            print("PJ cellForItemAt dla Item: \(indexPath.row)")
                
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICustomCollectionViewCell", for: indexPath) as! UICustomCollectionViewCell
                let item: Item
                if (isFiltering || isCategorySelected) {
                  item = filteredItemList[indexPath.row]
                } else {
                    item = itemList[indexPath.row] as! Item

                }
                cell.price.text = "\(item.itemPrice) €"  // dataSet[indexPath.row].price
                cell.title.text = item.itemName
                cell.image.sd_setImage(with: URL(string: item.itemImages[0]), placeholderImage: UIImage(named: "placeholder.png"))
                return cell //?? UICollectionViewCell()

                
            } else {
                print("PJ cellForItemAt dla AdView: \(indexPath.row)")
                
              let nativeAd = itemList[indexPath.row] as! GADUnifiedNativeAd
              /// Set the native ad's rootViewController to the current view controller.
              nativeAd.rootViewController = self

                let nativeAdCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NativeAdViewCell", for: indexPath) as! NativeAdViewCell

              // Get the ad view from the Cell. The view hierarchy for this cell is defined in
              // UnifiedNativeAdCell.xib.
                let adView : GADUnifiedNativeAdView = nativeAdCell.contentView.subviews.first as! GADUnifiedNativeAdView

              // Associate the ad view with the ad object.
              // This is required to make the ad clickable.
              adView.nativeAd = nativeAd

              // Populate the ad view with the ad assets.
                (adView.mediaView!).mediaContent = nativeAd.mediaContent

                (adView.iconView as! UIImageView).image = nativeAd.icon?.image
                (adView.callToActionView as! UIButton).setTitle(nativeAd.callToAction, for: .normal)
              (adView.headlineView as! UILabel).text = nativeAd.headline

              return nativeAdCell

            }
            
            
            
            
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoryCollectionView {
            print("PJ indexpath: \(indexPath.row) na catview: \(catSet[indexPath.row].name.lowercased())")
            
            if (catSet[indexPath.row].name.lowercased() != "all") {
                filterContentForSearchText(catSet[indexPath.row].name.lowercased())
                isCategorySelected = true
            } else {
                
                //TODO - przejrzec logike searchbaru, gdy jest cos w niego wpisane a ktos wybierze jakas kategorię;
                //albo na odwort ze kategoria wybrana i potem wyszukuje w danej kategorii
                
                //TODO - zrobic przygotowanie filtered items zeby wykluczyc reklamy z listy itemList
//                filteredItemList = itemList as! [Item]
                
                
                isCategorySelected = false
                
            
                print("PJ reload itemsCollectionView o rozmiarze: \(itemList.count)")
                itemsCollectionView.reloadData()
                
                
            }
            
            
        } else {
            print("PJ klikiety indexpath: \(indexPath.row) na collectionview: items)")

            let item: Item
            if (isFiltering || isCategorySelected) {
              item = filteredItemList[indexPath.row]
            } else {
                item = itemList[indexPath.row] as! Item
            }
       

            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailsViewController") as? ItemDetailsViewController
            {
                vc.itemNameText = item.itemName
                vc.itemPrice = "\(item.itemPrice) €"
                vc.itemImage = item.itemImages[0]
                vc.itemLocationLong = item.itemLocation.longitude
                vc.itemLocationLat = item.itemLocation.latitude
                vc.itemDescription = item.itemDescription
                vc.imagesArray = item.itemImages
                //TODO - jak chce zeby okno wchodzilo z boku to trzeba je pushowac z navigationController
//                if let navigator = navigationController {
//                    navigator.pushViewController(vc, animated: true)
//                }
          
                
                present(vc, animated: true, completion: nil)
            }
            
            
            
        }
    }
    


    
    
    
}



extension MainViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)

  }
}


extension MainViewController: CustomLayoutDelegate {
  func collectionView(
      _ collectionView: UICollectionView,
      heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    
    
    let arr : [CGFloat] = [250.0, 330.0, 275.0, 299.0]
    let h = arr.randomElement()!
//    print("PJ wyosowany height: \(h)")
    return h //photos[indexPath.item].image.size.height
  }
}


extension MainViewController : GADUnifiedNativeAdDelegate {

  func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
    print("\(#function) called")
  }

  func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
    print("\(#function) called")
  }

  func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
    print("\(#function) called")
  }
}


extension MainViewController : GADVideoControllerDelegate {

  func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
//    videoStatusLabel.text = "Video playback has ended."
  }
}

extension MainViewController : GADAdLoaderDelegate {

  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
    print("\(adLoader) failed with error: \(error.localizedDescription)")
//    refreshAdButton.isEnabled = true
  }
}



extension MainViewController : GADUnifiedNativeAdLoaderDelegate {

  func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
//    refreshAdButton.isEnabled = true
    
//    nativeAdView.nativeAd = nativeAd
//    (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
//      nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

    itemList.insert(nativeAd, at: itemList.count - 1)
    let indexPath = IndexPath(row: itemList.count - 1, section: 0)
//    print("PJ indexpath przed insertitem at: \(indexPath) i item: \(indexPath.item)")
    itemsCollectionView.insertItems(at: [indexPath])
    
    
    
    
    print("PJ odebrany nativeAD, itemlistCount = \(itemList.count)")
    // Set ourselves as the native ad delegate to be notified of native ad events.
    nativeAd.delegate = self

    // Deactivate the height constraint that was set when the previous video ad loaded.
    heightConstraint?.isActive = false

    // Populate the native ad view with the native ad assets.
    // The headline and mediaContent are guaranteed to be present in every native ad.
    
    print("PJ content reklaamy: headline=\(nativeAd.headline), body: \(nativeAd.body), price: \(nativeAd.price), CTA: \(nativeAd.callToAction), store: \(nativeAd.store), advertiser: \(nativeAd.advertiser), rating: \(nativeAd.starRating)")
    
   
    // Some native ads will include a video asset, while others do not. Apps can use the
    // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
    // UI accordingly.
    let mediaContent = nativeAd.mediaContent
    if mediaContent.hasVideoContent {
      // By acting as the delegate to the GADVideoController, this ViewController receives messages
      // about events in the video lifecycle.
      mediaContent.videoController.delegate = self
      print("PJ Ad contains a video asset.")
    }
    else {
      print("PJ Ad does not contain a video.")
    }
    

    print("PJ aspect ratio: \(nativeAd.mediaContent.aspectRatio)")

    // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
    // ratio of the media it displays.
    
    //TODO - to moze sie przydac
//    if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
//      heightConstraint = NSLayoutConstraint(item: mediaView,
//                                            attribute: .height,
//                                            relatedBy: .equal,
//                                            toItem: mediaView,
//                                            attribute: .width,
//                                            multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
//                                            constant: 0)
//      heightConstraint?.isActive = true
//    }


//    (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
//    nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
//
//    (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
//    nativeAdView.iconView?.isHidden = nativeAd.icon == nil
//
//    (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
//    nativeAdView.headlineView?.isHidden = nativeAd.headline == nil
//
//
//    nativeAdView.callToActionView?.isUserInteractionEnabled = false
    
    itemsCollectionView.reloadData()
    
  }
}

