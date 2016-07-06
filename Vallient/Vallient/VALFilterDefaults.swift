//
//  VALFilterDefaults.swift
//  Vallient
//
//  Created by Anthony Williams on 7/4/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import Foundation

class VALFilterDefaults {
    
    class func saveFilters(cityFilters: NSMutableArray, valuationFilters: NSMutableArray, statusFilters: NSMutableArray) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(cityFilters, forKey: "CityFilters")
        defaults.setObject(valuationFilters, forKey: "ValuationFilters")
        defaults.setObject(statusFilters, forKey: "StatusFilters")
        defaults.synchronize()
    }
    
    class func getFilters(key: String) -> NSMutableArray? {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let filters = defaults.objectForKey(key) as? NSMutableArray {
            if filters.count > 0 {
                return filters.mutableCopy() as? NSMutableArray
            }
        }
        
        return nil
    }
    
    class func getAllFilters() -> (NSMutableArray, NSMutableArray, NSMutableArray) {
        var cityFilters: NSMutableArray = []
        var valuationFilters: NSMutableArray = []
        var statusFilters: NSMutableArray = []
        
        if let cities = getFilters("CityFilters") {
            cityFilters = cities
        }
        if let valuations = getFilters("ValuationFilters") {
            valuationFilters = valuations
        }
        if let statuses = getFilters("StatusFilters") {
            statusFilters = statuses
        }
        
        return (cityFilters, valuationFilters, statusFilters)
    }
    
    class func predicateFromFilters() -> NSCompoundPredicate? {
        var filters: [NSPredicate] = []
        var compoundPredicate1: NSCompoundPredicate
        var compoundPredicate2: NSCompoundPredicate
        var compoundPredicate3: NSCompoundPredicate
        var subPredicates: [NSCompoundPredicate] = []

        if let cityFilters = VALFilterDefaults.getFilters("CityFilters") {
            for city in cityFilters {
                if let city = city as? String {
                    filters.append(NSPredicate(format: "city == %@", city))
                }
            }
            compoundPredicate1 = NSCompoundPredicate(orPredicateWithSubpredicates: filters)
            subPredicates.append(compoundPredicate1)
        }
        
        filters = []
        
        if let valuationFilters = VALFilterDefaults.getFilters("ValuationFilters") {
            for valuation in valuationFilters {
                if let valuation = valuation as? String {
                    filters.append(NSPredicate(format: "valuation == %@", valuation))
                }
            }
            compoundPredicate2 = NSCompoundPredicate(orPredicateWithSubpredicates: filters)
            subPredicates.append(compoundPredicate2)
        }
        
        filters = []
        
        if let statusFilters = VALFilterDefaults.getFilters("StatusFilters") {
            for status in statusFilters {
                if let status = status as? String {
                    filters.append(NSPredicate(format: "status == %@", status))
                }
            }
            compoundPredicate3 = NSCompoundPredicate(orPredicateWithSubpredicates: filters)
            subPredicates.append(compoundPredicate3)
        }
        
        if subPredicates.count > 0 {
            return NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
        }
        
        return nil
    }
}