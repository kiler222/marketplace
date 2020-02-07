//
//  ItemDetailsViewController.swift
//  yogismarket
//
//  Created by kiler on 06/02/2020.
//  Copyright © 2020 kiler. All rights reserved.
//

import UIKit
import MapKit

class ItemDetailsViewController: UIViewController, UIScrollViewDelegate {

    var frame = CGRect.zero
    var itemNameText = ""
    var itemImage = ""
    var imagesArray : [String] = []
    var itemPrice = ""
    var itemLocationLong: Double = 0.0
    var itemLocationLat: Double = 0.0
    var itemDescription = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel lorem."//Etiam pellentesque aliquet tellus. Phasellus pharetra nulla ac diam. Quisque semper justo at risus. Donec venenatis, turpis vel hendrerit interdum, dui ligula ultricies purus, sed posuere libero dui id orci."
    
    @IBOutlet weak var itemPriceField: UILabel!
    @IBOutlet weak var itemImageField: UIImageView!
    @IBOutlet weak var itemNameField: UILabel!
    @IBOutlet weak var mapField: MKMapView!
    @IBOutlet weak var itemDescriptionField: UILabel!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScreens()

        imagesScrollView.delegate = self
        pageControl.numberOfPages = imagesArray.count
        itemNameField.text = itemNameText
        itemPriceField.text = itemPrice
        itemDescriptionField.text = itemDescription
        itemImageField.sd_setImage(with: URL(string: itemImage), placeholderImage: UIImage(named: "placeholder.png"))
        print("PJ long: \(itemLocationLat), lat: \(itemLocationLong)")
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let locValue = CLLocationCoordinate2DMake(itemLocationLat, itemLocationLong)
        
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapField.setRegion(region, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func setupScreens() {
        for index in 0..<imagesArray.count {
            // 1.
            frame.origin.x = imagesScrollView.frame.size.width * CGFloat(index)
            frame.size = imagesScrollView.frame.size
            
            // 2.
            let imgView = UIImageView(frame: frame)
            imgView.sd_setImage(with: URL(string: imagesArray[index]), placeholderImage: UIImage(named: "placeholder.png"))
            imgView.contentMode = .scaleAspectFill
            self.imagesScrollView.addSubview(imgView)
        }

        // 3.
        imagesScrollView.contentSize = CGSize(width: (imagesScrollView.frame.size.width * CGFloat(imagesArray.count)), height: imagesScrollView.frame.size.height)
        imagesScrollView.delegate = self
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
}
