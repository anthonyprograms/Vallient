//
//  VALCompanyEventsViewController.swift
//  Vallient
//
//  Created by Anthony Williams on 7/16/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import SafariServices

class VALCompanyEventsViewController: UIViewController {

    let tableView = UITableView()
    var companyName: String?
    var events: [NSDictionary] = []
    
    var managedContext: NSManagedObjectContext!
    
    var eventCache: VALEventCache!
    
    init(companyName: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.companyName = companyName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        eventCache = VALEventCache(managedContext: managedContext)
        
        self.navigationController?.navigationBarHidden = false
        
        self.title = companyName
        
        if let companyName = companyName {
            VALHTTPClient().getEventsByCompanyName(companyName) { data in
                if let events = data as? [NSDictionary] {
                    self.eventCache.emptyCoreData()
                    self.eventCache.saveEvent(events)
                    
                    self.getEventsAndUpdateView()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configureView() {
        tableView.frame = view.frame
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor.clearColor()
        tableView.bounces = true
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    func getEventsAndUpdateView() {
        if let events = eventCache.getEvents(self.companyName!) {
            self.events = events
            self.tableView.reloadData()
        }
    }
}

extension VALCompanyEventsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.imageView?.image = nil
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 16)
        cell.backgroundColor = .clearColor()
        cell.textLabel?.textColor = .blackColor()
        cell.textLabel?.textAlignment = .Center
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .None
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "\(events[indexPath.section]["name"]!)"
            cell.textLabel?.font = UIFont(name: "Helvetica", size: 22)
            cell.textLabel?.textColor = UIColor.vallientPrimaryColor()
        case 1:
            cell.textLabel?.text = "Hosted by \(events[indexPath.section]["host"]!)"
        case 2:
            cell.textLabel?.text = "\(events[indexPath.section]["address"]!)"
        case 3:
            cell.textLabel?.text = "\(events[indexPath.section]["time"]!)"
        case 4:
            cell.textLabel?.text = "\(events[indexPath.section]["info"]!)"
        case 5:
            cell.textLabel?.text = "\(events[indexPath.section]["amenities"]!)"
        case 6:
            cell.textLabel?.text = "\(events[indexPath.section]["price"]!)"
        case 7:
            cell.textLabel?.text = "More"
            cell.backgroundColor = UIColor(red: 56/255, green: 96/255, blue: 179/255, alpha: 1)
            cell.textLabel?.textColor = .whiteColor()
        default:
            break
        }

        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(events[section]["date"]!)"
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 7 {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            alertController.addAction(UIAlertAction(title: "Map", style: .Default, handler: { (action) in
                guard let name = self.events[indexPath.section]["name"]! as? String,
                    let coordinates = self.events[indexPath.section]["coordinates"]! as? Array<NSNumber>,
                    let latitude = coordinates[0] as? NSNumber,
                    let longitude = coordinates[1] as? NSNumber else { return }
                
                VALMethods.mapToLocation(name, coordinates: CLLocationCoordinate2DMake(Double(latitude), Double(longitude)))
            }))
            
            alertController.addAction(UIAlertAction(title: "Website Link", style: .Default, handler: { (action) in
                guard let site = self.events[indexPath.section]["link"]! as? String else { return }
                
                self.openSafariViewController(site)
            }))
            
            alertController.addAction(UIAlertAction(title: "Share", style: .Default, handler: { (action) in
                guard let url = self.events[indexPath.section]["link"]! as? String else { return }
                VALMethods.shareSheet(url, viewController: self)
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

extension VALCompanyEventsViewController: SFSafariViewControllerDelegate {
    func openSafariViewController(site: String) {
        let safariViewController = SFSafariViewController(URL: NSURL(string: site)!)
        safariViewController.delegate = self
        self.presentViewController(safariViewController, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}