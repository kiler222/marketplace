//
//  ViewController.swift
//  yogismarket
//
//  Created by kiler on 28/01/2020.
//  Copyright © 2020 kiler. All rights reserved.
//

import UIKit
import SDWebImage


class ViewXXController: UICollectionViewController, CustomLayoutDelegate {
    
    public var customCollectionViewLayout: UICustomCollectionViewLayout? {
        get {
            return collectionViewLayout as? UICustomCollectionViewLayout
        }
        set {
            if newValue != nil {
                self.collectionView?.collectionViewLayout = newValue!
                
            }
        }
    }
    
    struct Model {
        var index: Int
        var price: String
        var title: String
        var isBig: Bool
    }
    
    private let dataSet = [Model(index: 1, price: "9$", title: "Yoga pants", isBig: false), Model(index: 2, price: "9$", title: "Yoga pants", isBig: false), Model(index: 3, price: "9$", title: "Yoga pants", isBig: false),
                           Model(index: 4, price: "3$", title: "Yoga pants", isBig: true), Model(index: 5, price: "9$", title: "Yoga pants", isBig: false), Model(index: 6, price: "9$", title: "My yoga pants", isBig: false),
                           Model(index: 7, price: "9$", title: "Yoga pants", isBig: false), Model(index: 8, price: "9$", title: "Yoga pants", isBig: false), Model(index: 9, price: "12$", title: "Old one yoga pants", isBig: false),
                           Model(index: 10, price: "9$", title: "Yoga pants", isBig: false), Model(index: 11, price: "9$", title: "Yoga pants", isBig: false), Model(index: 12, price: "9$", title: "Yoga pants", isBig: false)]
    
    
    let obrazki = [  "https://bambooclothing.co.uk/wp-content/uploads/BAM1135-yoga-jersey-pants-ocean-teal-bamboo-clothing-1-2-683x1024.jpg", "https://media.karousell.com/media/photos/products/2018/06/28/lululemon__domyos_yoga_tops_1530174290_90ceca2d_progressive.jpg",
    "https://media.karousell.com/media/photos/products/2019/06/09/lulu_lemon_yoga_tops_1560055780_55c759de_progressive.jpg",
    "https://i.etsystatic.com/12414401/r/il/5c29b1/1392029807/il_fullxfull.1392029807_7nf9.jpg",
    "https://i.etsystatic.com/9456292/r/il/724e25/857454993/il_fullxfull.857454993_hxk6.jpg",
    "https://i.etsystatic.com/12203369/r/il/5b11bd/2097111020/il_fullxfull.2097111020_f3br.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customCollectionViewLayout?.delegate = self
        self.customCollectionViewLayout?.numberOfColumns = 2
        //self.customCollectionViewLayout?.cellPadding = 30
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSet.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICustomCollectionViewCell", for: indexPath) as? UICustomCollectionViewCell
        cell?.price.text = dataSet[indexPath.row].price
        cell?.title.text = dataSet[indexPath.row].title
        cell?.image.sd_setImage(with: URL(string: obrazki.randomElement()!), placeholderImage: UIImage(named: "placeholder.png"))

        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForItemAt
                        indexPath: IndexPath,
                        with width: CGFloat) -> CGFloat {
        
//        let heightSizes = [100,216]
        
        let height = Int.random(in: 300...350)
        
        print("PJ height: \(height)")
//        return CGFloat(heightSizes[dataSet[indexPath.row].isBig ? 1 : 0])
        return CGFloat(height)
    }
}
