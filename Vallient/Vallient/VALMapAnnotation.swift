//
//  VALMapAnnotation.swift
//  Vallient
//
//  Created by Anthony Williams on 6/19/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import MapKit

class VALMapAnnotation: MKPointAnnotation {
    
    var imageUrl: String!
    var info: String!
    var address: String!
    var site: String!
    var company: NSDictionary!
    
    init(company: NSDictionary) {
        super.init()

        self.company = company
        
        if let name = company["name"] as? String {
            self.title = name
        }
        
        if let latitude = company["latitude"] as? NSNumber {
            if let longitude = company["longitude"] as? NSNumber {
                self.coordinate = CLLocationCoordinate2DMake(Double(longitude), Double(latitude))
            }
        }
    }
}
