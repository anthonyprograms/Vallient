//
//  Event+CoreDataProperties.swift
//  Vallient
//
//  Created by Anthony Williams on 7/16/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var name: String?
    @NSManaged var date: String?
    @NSManaged var time: String?
    @NSManaged var address: String?
    @NSManaged var amenities: String?
    @NSManaged var host: String?
    @NSManaged var info: String?
    @NSManaged var link: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var price: String?

}
