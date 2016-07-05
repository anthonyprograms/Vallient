//
//  Company+CoreDataProperties.swift
//  Vallient
//
//  Created by Anthony Williams on 6/26/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Company {

    @NSManaged var name: String?
    @NSManaged var info: String?
    @NSManaged var address: String?
    @NSManaged var site: String?
    @NSManaged var status: String?
    @NSManaged var imageUrl: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var tag: String?
    @NSManaged var city: String?
    @NSManaged var valuation: String?

}
