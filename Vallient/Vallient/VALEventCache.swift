//
//  VALEventCache.swift
//  Vallient
//
//  Created by Anthony Williams on 7/17/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import CoreData

class VALEventCache: NSObject {
    var managedContext: NSManagedObjectContext!
    let eventEntityName = "Event"
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func getEvents(companyName: String) -> [NSDictionary]? {
        let eventFetch = NSFetchRequest(entityName: eventEntityName)
        eventFetch.returnsObjectsAsFaults = true
        eventFetch.resultType = .DictionaryResultType
        eventFetch.fetchBatchSize = 15
        eventFetch.predicate = NSPredicate(format: "host == %@", companyName)
        
        do {
            let results = try managedContext.executeFetchRequest(eventFetch)
            
            if let results = results as? [NSDictionary] {
                return results
            }
        } catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func saveEvent(events: [NSDictionary]) {
        let eventEntity = NSEntityDescription.entityForName(eventEntityName, inManagedObjectContext: managedContext)
        
        for eventData in events {
            let event = Event(entity: eventEntity!, insertIntoManagedObjectContext: managedContext)
            event.name = "\(eventData["name"]!)"
            event.info = "\(eventData["info"]!)"
            event.date = "\(eventData["date"]!)"
            event.address = "\(eventData["address"]!)"
            let coordinates = eventData["coordinates"] as! Array<NSNumber>
            event.latitude = coordinates[0] as? NSNumber
            event.longitude = coordinates[1] as? NSNumber
            event.time = "\(eventData["time"]!)"
            event.amenities = "\(eventData["amenities"]!)"
            event.host = "\(eventData["host"]!)"
            event.info = "\(eventData["info"]!)"
            event.link = "\(eventData["link"]!)"
            event.price = "\(eventData["price"]!)"
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error: \(error) " +
                    "description \(error.localizedDescription)")
            }
        }
    }
    
    func emptyCoreData() {
        let entity = "Event"
        let fetchRequest = NSFetchRequest(entityName: entity)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}
