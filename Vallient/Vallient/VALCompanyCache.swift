//
//  VALCompanyCache.swift
//  Vallient
//
//  Created by Anthony Williams on 7/4/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class VALCompanyCache {
    
    var managedContext: NSManagedObjectContext!
    let companyEntityName = "Company"
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func getCompanies(location: CLLocationCoordinate2D, span: MKCoordinateSpan) -> [NSDictionary]? {
        let companyFetch = NSFetchRequest(entityName: companyEntityName)
        companyFetch.returnsObjectsAsFaults = true
        companyFetch.resultType = .DictionaryResultType
        companyFetch.fetchBatchSize = 15
        
        let minLatitude = location.latitude - span.latitudeDelta
        let maxLatitude = location.latitude + span.latitudeDelta
        let minLongitude = location.longitude - span.longitudeDelta
        let maxLongitude = location.longitude + span.longitudeDelta
        let regionalPredicate = NSPredicate(format: "latitude >= %f AND latitude <= %f AND longitude >= %f AND longitude <= %f", minLatitude, maxLatitude, minLongitude, maxLongitude)
        
        if let compoundPredicate = VALFilterDefaults.predicateFromFilters() {
            companyFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [regionalPredicate, compoundPredicate])
        } else {
            companyFetch.predicate = regionalPredicate
        }
        
        do {
            let results = try managedContext.executeFetchRequest(companyFetch)
            
            if let results = results as? [NSDictionary] {
                return results
            }
        } catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func saveCompany(companies: [NSDictionary]) {
        let companyEntity = NSEntityDescription.entityForName(companyEntityName, inManagedObjectContext: managedContext)
        
        for companyData in companies {
            let company = Company(entity: companyEntity!, insertIntoManagedObjectContext: managedContext)
            company.name = "\(companyData["name"]!)"
            company.info = "\(companyData["info"]!)"
            company.imageUrl = "\(companyData["imageUrl"]!)"
            company.address = "\(companyData["address"]!)"
            let coordinates = companyData["coordinates"] as! Array<NSNumber>
            company.latitude = coordinates[1] as? NSNumber
            company.longitude = coordinates[0] as? NSNumber
            company.site = "\(companyData["site"]!)"
            company.status = "\(companyData["type"]!)"
            company.tag = "\(companyData["tag"]!)"
            company.valuation = "\(companyData["valuation"]!)"
            company.city = "\(companyData["city"]!)"
        
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error: \(error) " +
                    "description \(error.localizedDescription)")
            }
        }
    }
    
    func emptyCoreData() {
        let entity = "Company"
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
    
    func getRelatedCompanies(companyName: String, companyTag: String) -> [NSDictionary]? {
        let companyFetch = NSFetchRequest(entityName: companyEntityName)
        companyFetch.returnsObjectsAsFaults = true
        companyFetch.resultType = .DictionaryResultType
        companyFetch.fetchBatchSize = 6
        
        companyFetch.predicate = NSPredicate(format: "name != %@ AND tag == %@", companyName, companyTag)
//        companyFetch.predicate = NSPredicate(format: "name != %@", companyName)
        
        do {
            let results = try managedContext.executeFetchRequest(companyFetch)
            
            if let results = results as? [NSDictionary] {
                return results
            }
        } catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
        
        return nil
    }
}