//
//  ShowImageViewController.swift
//  yogismarket
//
//  Created by kiler on 07/02/2020.
//  Copyright © 2020 kiler. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var frame = CGRect.zero
    
    var imagesArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScreens()

        scrollView.delegate = self
        pageControl.numberOfPages = imagesArray.count
        
        
    }
    

    func setupScreens() {
        for index in 0..<imagesArray.count {
            // 1.
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            // 2.
            let imgView = UIImageView(frame: frame)
            imgView.sd_setImage(with: URL(string: imagesArray[index]), placeholderImage: UIImage(named: "placeholder.png"))
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            
            self.scrollView.addSubview(imgView)
        }

        // 3.
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(imagesArray.count)), height: scrollView.frame.size.height/4)
        print("PJ heigjht: \(scrollView.frame.size.height)")
        scrollView.delegate = self
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    

}
