//
//  VALHTTPClient.swift
//  Vallient
//
//  Created by Anthony Williams on 6/19/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import Alamofire

class VALHTTPClient: NSObject {
    
    let domain = "http://ec2-52-40-221-15.us-west-2.compute.amazonaws.com"
    
    func getCompanies(completion: (data: AnyObject) -> ()) {
        Alamofire.request(.GET, "\(domain)/api/company", parameters: nil)
            .responseJSON { response in
                if let JSON = response.result.value {
                    completion(data: JSON)
                }
        }
    }
    
    func getAllEvents(completion: (data: AnyObject) -> ()) {
        Alamofire.request(.GET, "\(domain)/api/event", parameters: nil)
            .responseJSON { response in
                if let JSON = response.result.value {
                    completion(data: JSON)
                }
        }
    }
    
    func getEventsByCompanyName(companyName: String, completion: (data: AnyObject) -> ()) {
        Alamofire.request(.GET, "\(domain)/api/event", parameters: nil)
            .responseJSON { response in
                if let JSON = response.result.value {
                    completion(data: JSON)
                }
        }
    }
}
