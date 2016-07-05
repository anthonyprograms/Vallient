//
//  VALFilterDefaults.swift
//  Vallient
//
//  Created by Anthony Williams on 7/4/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import Foundation

class VALFilterDefaults {
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

        if let cityFilters = VALFilterDefaults.getFilters("CityFilters") {
            for city in cityFilters {
                if let city = city as? String {
                    filters.append(NSPredicate(format: "city == %@", city))
                }
            }
        }
        if let valuationFilters = VALFilterDefaults.getFilters("ValuationFilters") {
            for valuation in valuationFilters {
                if let valuation = valuation as? String {
                    filters.append(NSPredicate(format: "valuation == %@", valuation))
                }
            }
        }
        if let statusFilters = VALFilterDefaults.getFilters("StatusFilters") {
            for status in statusFilters {
                if let status = status as? String {
                    filters.append(NSPredicate(format: "status == %@", status))
                }
            }
        }
        if filters.count > 0 {
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: filters)
            return compoundPredicate
        }
        
        return nil
    }
}