//
//  MainViewController.swift
//  yogismarket
//
//  Created by kiler on 28/01/2020.
//  Copyright © 2020 kiler. All rights reserved.
//

import Foundation
import UIKit



class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var itemsCollectionView: UICollectionView!

    
    var itemList : [Item] = []
    var filteredItemList : [Item] = []
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
             return searchController.searchBar.text?.isEmpty ?? true
           }
           
    var isFiltering: Bool {
             return searchController.isActive && !isSearchBarEmpty
           }
    
    
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
    
//    private let dataSet = [Model(index: 1, price: "9$", title: "Yoga New pants", isBig: false), Model(index: 2, price: "9$", title: "Yoga black bag", isBig: false), Model(index: 3, price: "9$", title: "Yoga pants", isBig: false),
//                           Model(index: 4, price: "3$", title: "Another yoga pants", isBig: true), Model(index: 5, price: "9$", title: "Yoga cool pants", isBig: false), Model(index: 6, price: "9$", title: "My yoga pants", isBig: false),
//                           Model(index: 7, price: "9$", title: "Yoga cookbook", isBig: false), Model(index: 8, price: "9$", title: "Yoga mat", isBig: false), Model(index: 9, price: "12$", title: "Old one yoga pants", isBig: false),
//                           Model(index: 10, price: "9$", title: "Yoga Top", isBig: false), Model(index: 11, price: "9$", title: "Yoga bag", isBig: false), Model(index: 12, price: "9$", title: "Yoga Green pants", isBig: false)]
    
    let cat = ["Mats", "Pants", "Bras", "Tops", "Bags", "Accessories", "Books", "Other" ]
    
    private let catSet = [Categories(name: "Mats", image: UIImage(systemName: "rectangle")!),
                          Categories(name: "Pants", image: UIImage(systemName: "sun.max")!),
                          Categories(name: "Bras", image: UIImage(systemName: "person")!),
                          Categories(name: "Tops", image: UIImage(systemName: "flame")!),
                          Categories(name: "Bags", image: UIImage(systemName: "bag")!),
                          Categories(name: "Accessories", image: UIImage(systemName: "cart")!),
                          Categories(name: "Books", image: UIImage(systemName: "book")!),
                          Categories(name: "Other", image: UIImage(systemName: "globe")!)
        ]
    
//    let obrazki = [  "https://bambooclothing.co.uk/wp-content/uploads/BAM1135-yoga-jersey-pants-ocean-teal-bamboo-clothing-1-2-683x1024.jpg", "https://media.karousell.com/media/photos/products/2018/06/28/lululemon__domyos_yoga_tops_1530174290_90ceca2d_progressive.jpg",
//    "https://media.karousell.com/media/photos/products/2019/06/09/lulu_lemon_yoga_tops_1560055780_55c759de_progressive.jpg",
//    "https://i.etsystatic.com/12414401/r/il/5c29b1/1392029807/il_fullxfull.1392029807_7nf9.jpg",
//    "https://i.etsystatic.com/9456292/r/il/724e25/857454993/il_fullxfull.857454993_hxk6.jpg",
//    "https://i.etsystatic.com/12203369/r/il/5b11bd/2097111020/il_fullxfull.2097111020_f3br.jpg"]
//
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        
       
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

    
    func filterContentForSearchText(_ searchText: String,
                                    category: Item.Category? = nil) {
      filteredItemList = itemList.filter { (item: Item) -> Bool in
        return item.category.lowercased().contains(searchText.lowercased())
      }
      
      itemsCollectionView.reloadData()
    }
    


    
    //UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        
        return 4
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.categoryCollectionView{
            return CGSize(width: 100,height: 75)
        } else {
           let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
           let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (itemsCollectionView.frame.size.width - space) / 2.0
            let shift = Int.random(in: -3...3)*10
            
            return CGSize(width: size, height: size*1.5 )
        }
    
    }
    

    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.categoryCollectionView{
            return cat.count
        } else {
            if isFiltering {
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
            
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICustomCollectionViewCell", for: indexPath) as! UICustomCollectionViewCell
            
            let item: Item
            if isFiltering {
              item = filteredItemList[indexPath.row]
            } else {
              item = itemList[indexPath.row]
            }
            
            
            cell.price.text = "\(item.itemPrice) €"  // dataSet[indexPath.row].price
            cell.title.text = item.itemName
            cell.image.sd_setImage(with: URL(string: item.itemImages[0]), placeholderImage: UIImage(named: "placeholder.png"))
          
//            print("PJ indexPath: \(indexPath.row) i price: \(dataSet[indexPath.row].price)")
            return cell //?? UICollectionViewCell()
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoryCollectionView {
            print("PJ klikiety indexpath: \(indexPath.row) na collectionview: cat)")
        } else {
            print("PJ klikiety indexpath: \(indexPath.row) na collectionview: items)")
            
//            let vc  = storyboard?.instantiateViewController(withIdentifier: "ItemDetailsViewController") as! ItemDetailsViewController
            
       
//            vc.itemNameText = "dataSet[indexPath.row].title"

            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailsViewController") as? ItemDetailsViewController
            {
                vc.itemNameText = itemList[indexPath.row].itemName
                vc.itemPrice = "\(itemList[indexPath.row].itemPrice) €"
                vc.itemImage = itemList[indexPath.row].itemImages[0]
                vc.itemLocationLong = itemList[indexPath.row].itemLocation.longitude
                vc.itemLocationLat = itemList[indexPath.row].itemLocation.latitude
                vc.itemDescription = itemList[indexPath.row].itemDescription
                //TODO - jak chce zeby okno wchodzilo z boku to trzeba je pushowac z navigationController
//                if let navigator = navigationController {
//                    navigator.pushViewController(vc, animated: true)
//                }
          
                
                present(vc, animated: true, completion: nil)
            }
            

//            performSegue(withIdentifier: "ShowItemDetails", sender: nil)
            
//                    pushVC(viewController: vc)
            
            
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                print("PJ czy robie prepare segue? \(segue.identifier)")
        
        if segue.identifier == "ShowItemDetails"
        {
            
            if let destinationVC = segue.destination as? ItemDetailsViewController {
            print("PJ ustawienie itename w segue")
                destinationVC.itemNameText = itemName
            }
        }
    }
    
    

    
    
    
    
    // custom function to generate a random UIColor
//    func randomColor() -> UIColor{
//        let red = CGFloat(drand48())
//        let green = CGFloat(drand48())
//        let blue = CGFloat(drand48())
//        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
//    }
    
    
//    public func getViewController(name : String) -> MainViewController{
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: name) as! MainViewController
//        return vc
//    }
//
//    public func pushVC(viewController : UIViewController){
//        self.navigationController?.pushViewController(viewController, animated: true)
//    }
}



extension MainViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)

  }
}
