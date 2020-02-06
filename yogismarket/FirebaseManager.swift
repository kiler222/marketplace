//
//  FirebaseManager.swift
//  yogismarket
//
//  Created by kiler on 06/02/2020.
//  Copyright © 2020 kiler. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MapKit

class FirebaseManager: NSObject {

    public var token : String?
    static let sharedInstance  = FirebaseManager()
    var db: Firestore!

    func getItems(completion: @escaping (Array<Item>) -> Void){
        print("PJ get Items")
        db = Firestore.firestore()
        
        db.collection("items").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("PJ Error getting documents: \(err)")
            } else {
                var itemList: [Item] = []
                for document in querySnapshot!.documents {
                   
                    let itemName = document.data()["itemName"] as! String
                    let itemPrice = document.data()["itemPrice"] as! Int
                    let itemDescription = document.data()["itemDescription"] as! String
                    let itemLocation = document.data()["itemLocation"] as! GeoPoint
                    let itemImages = document.data()["itemImages"] as! Array<String>
                    
                    let tempItem = Item(itemName: itemName, itemPrice: itemPrice,
                                        itemDescription: itemDescription, itemImages: itemImages,
                                        itemLocation: itemLocation)
//                    print("PJ \(document.documentID) => \(document.data())")
                    itemList.append(tempItem)
                }
                
              
                completion(itemList)
                
                
            }
        }
        
    }

    
    
    
}
