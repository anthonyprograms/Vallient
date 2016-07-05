//
//  VALFilterViewController.swift
//  Vallient
//
//  Created by Anthony Williams on 6/26/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import CoreData

class VALFilterViewController: UIViewController {

    var tableView: UITableView!
    
    let itemSections = ["City", "Valuation", "Status"]
    let city = ["San Francisco", "Silicon Valley"]
    let valuation = ["1M", "10M", "100M", "1B", "10B+"]
    let status = ["Public", "Startup", "Investor"]
    
    var cityFilters: NSMutableArray = []
    var valuationFilters: NSMutableArray = []
    var statusFilters: NSMutableArray = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        initTableView()
    }
    
    func initTableView() {
        tableView = UITableView(frame: view.frame)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.clearColor()
        tableView.allowsMultipleSelection = true
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(self.tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Filters"
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        let applyButton = UIBarButtonItem(title: "Apply", style: .Done, target: self, action: #selector(VALFilterViewController.applyFilters))
        self.navigationItem.rightBarButtonItem = applyButton
        
       (cityFilters, valuationFilters, statusFilters) = VALFilterDefaults.getAllFilters()
    }
    
    func applyFilters() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(cityFilters, forKey: "CityFilters")
        defaults.setObject(valuationFilters, forKey: "ValuationFilters")
        defaults.setObject(statusFilters, forKey: "StatusFilters")
        defaults.synchronize()
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension VALFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return itemSections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return city.count
        } else if section == 1 {
            return valuation.count
        } else {
            return status.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        cell.selectionStyle = .None
        
        if indexPath.section == 0 {
            cell.textLabel?.text = city[indexPath.row]
            
            if cityFilters.containsObject(city[indexPath.row]) {
                cell.accessoryType = .Checkmark
            }
        } else if indexPath.section == 1 {
            cell.textLabel?.text = valuation[indexPath.row]
            
            if valuationFilters.containsObject(valuation[indexPath.row]) {
                cell.accessoryType = .Checkmark
            }
        } else {
            cell.textLabel?.text = status[indexPath.row]
            
            if statusFilters.containsObject(status[indexPath.row]) {
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return itemSections[section]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        
        if indexPath.section == 0 {
            cityFilters.addObject(city[indexPath.row])
        } else if indexPath.section == 1 {
            valuationFilters.addObject(valuation[indexPath.row])
        } else {
            statusFilters.addObject(status[indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
        
        if indexPath.section == 0 {
            cityFilters.removeObject(city[indexPath.row])
        } else if indexPath.section == 1 {
            valuationFilters.removeObject(valuation[indexPath.row])
        } else {
            statusFilters.removeObject(status[indexPath.row])
        }
    }
}