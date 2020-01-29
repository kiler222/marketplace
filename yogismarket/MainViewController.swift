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

    
    struct Model {
        var index: Int
        var price: String
        var title: String
        var isBig: Bool
    }

    struct Categories {
        var name: String
        var image: UIImage

    }
    
    private let dataSet = [Model(index: 1, price: "9$", title: "Yoga pants", isBig: false), Model(index: 2, price: "9$", title: "Yoga pants", isBig: false), Model(index: 3, price: "9$", title: "Yoga pants", isBig: false),
                           Model(index: 4, price: "3$", title: "Yoga pants", isBig: true), Model(index: 5, price: "9$", title: "Yoga pants", isBig: false), Model(index: 6, price: "9$", title: "My yoga pants", isBig: false),
                           Model(index: 7, price: "9$", title: "Yoga pants", isBig: false), Model(index: 8, price: "9$", title: "Yoga pants", isBig: false), Model(index: 9, price: "12$", title: "Old one yoga pants", isBig: false),
                           Model(index: 10, price: "9$", title: "Yoga pants", isBig: false), Model(index: 11, price: "9$", title: "Yoga pants", isBig: false), Model(index: 12, price: "9$", title: "Yoga pants", isBig: false)]
    
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
    
    let obrazki = [  "https://bambooclothing.co.uk/wp-content/uploads/BAM1135-yoga-jersey-pants-ocean-teal-bamboo-clothing-1-2-683x1024.jpg", "https://media.karousell.com/media/photos/products/2018/06/28/lululemon__domyos_yoga_tops_1530174290_90ceca2d_progressive.jpg",
    "https://media.karousell.com/media/photos/products/2019/06/09/lulu_lemon_yoga_tops_1560055780_55c759de_progressive.jpg",
    "https://i.etsystatic.com/12414401/r/il/5c29b1/1392029807/il_fullxfull.1392029807_7nf9.jpg",
    "https://i.etsystatic.com/9456292/r/il/724e25/857454993/il_fullxfull.857454993_hxk6.jpg",
    "https://i.etsystatic.com/12203369/r/il/5b11bd/2097111020/il_fullxfull.2097111020_f3br.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        itemsCollectionView.delegate = self
        
        itemsCollectionView.dataSource = self

//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical //.horizontal
//        layout.minimumLineSpacing = 5
//        layout.minimumInteritemSpacing = 5
//        itemsCollectionView.setCollectionViewLayout(layout, animated: true)
        
        
        print("PJ viewDidLoad")
        
//        self.itemsCollectionView?.delegate = self
//        self.itemsCollectionView?.numberOfColumns = 2
        //self.customCollectionViewLayout?.cellPadding = 30
    }

    
    
//    func collectionView(_ collectionView: UICollectionView,
//                        heightForItemAt
//                        indexPath: IndexPath,
//                        with width: CGFloat) -> CGFloat {
//        if collectionView == self.itemsCollectionView{
//            let height = Int.random(in: 300...350)
//            print("PJ height: \(height)")
//            return CGFloat(height)
//        } else {
//            return CGFloat(50)
//
//        }
//
//    }
 
 

    
    //UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        
        return 4;
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        
        return 1;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.categoryCollectionView{
            return CGSize(width: 100,height: 75)
        } else {
           let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
           let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (itemsCollectionView.frame.size.width - space) / 2.0
            let shift = Int.random(in: -3...3)*10
            
//            CGFloat(shift)
//            let height = 2*size + shift.
//            print("PJ shift: \(shift) cgfloat: \(CGFloat(shift))")
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
            return dataSet.count
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
            cell.price.text = dataSet[indexPath.row].price
            cell.title.text = dataSet[indexPath.row].title
            cell.image.sd_setImage(with: URL(string: obrazki.randomElement()!), placeholderImage: UIImage(named: "placeholder.png"))
          
            print("PJ indexPath: \(indexPath.row) i price: \(dataSet[indexPath.row].price)")
            return cell //?? UICollectionViewCell()
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoryCollectionView {
            print("PJ klikiety indexpath: \(indexPath.row) na collectionview: cat)")
        } else {
            print("PJ klikiety indexpath: \(indexPath.row) na collectionview: items)")
        }
    }
    
    
    // custom function to generate a random UIColor
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
}
