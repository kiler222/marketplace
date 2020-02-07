//
//  Models.swift
//  yogismarket
//
//  Created by kiler on 06/02/2020.
//  Copyright © 2020 kiler. All rights reserved.
//

import Foundation
import MapKit
import FirebaseFirestore

struct Item {
    let itemName: String
    let itemPrice: Int
    let itemDescription: String
    let itemImages: Array<String>
    let itemLocation: GeoPoint
    let category: String
    
    enum Category {
      case all
      case pants
      case mats
      case other
    }
}
