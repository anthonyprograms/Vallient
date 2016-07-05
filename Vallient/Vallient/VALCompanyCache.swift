//
//  VALCompanyCache.swift
//  Vallient
//
//  Created by Anthony Williams on 7/4/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import Foundation
import CoreData

class VALCompanyCache {
    
    var managedContext: NSManagedObjectContext!
    let companyEntityName = "Company"
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func getCompanies() -> [NSDictionary]? {
        let companyFetch = NSFetchRequest(entityName: companyEntityName)
        companyFetch.returnsObjectsAsFaults = true
        companyFetch.resultType = .DictionaryResultType
        companyFetch.fetchBatchSize = 15
        
        if let compoundPredicate = VALFilterDefaults.predicateFromFilters() {
            companyFetch.predicate = compoundPredicate
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
        for companyData in companies {
            let companyEntity = NSEntityDescription.entityForName(companyEntityName, inManagedObjectContext: managedContext)
            let company = Company(entity: companyEntity!, insertIntoManagedObjectContext: managedContext)
            company.name = "\(companyData["name"]!)"
            company.info = "\(companyData["info"]!)"
            company.imageUrl = "\(companyData["imageUrl"]!)"
            company.address = "\(companyData["address"]!)"
            company.latitude = companyData["coordinates"]![0] as? NSNumber
            company.longitude = companyData["coordinates"]![1] as? NSNumber
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
        
//        companyFetch.predicate = NSPredicate(format: "name != %@ AND tag == %@", companyName, companyTag)
        companyFetch.predicate = NSPredicate(format: "name != %@", companyName)
        companyFetch.fetchBatchSize = 6
        
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