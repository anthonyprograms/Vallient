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
        
        view.backgroundColor = UIColor.vallientPrimaryColor()
        
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
        VALFilterDefaults.saveFilters(cityFilters, valuationFilters: valuationFilters, statusFilters: statusFilters)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension VALFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return itemSections.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 40))
        headerView.backgroundColor = UIColor.vallientPrimaryColor()
        
        let textLabel = UILabel(frame: headerView.frame)
        textLabel.text = itemSections[section]
        textLabel.textColor = UIColor.whiteColor()
        textLabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        textLabel.textAlignment = .Center
        headerView.addSubview(textLabel)
        
        return headerView
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
        cell.backgroundColor = .clearColor()
        
        if indexPath.section == 0 {
            // Remove current check mark
            // Place on new place
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
        if tableView.cellForRowAtIndexPath(indexPath)?.accessoryType == .Checkmark {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
        } else {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        
        if indexPath.section == 0 {
            toggleFilter(cityFilters, object: city[indexPath.row])
        } else if indexPath.section == 1 {
            toggleFilter(valuationFilters, object: valuation[indexPath.row])
        } else {
            toggleFilter(statusFilters, object: status[indexPath.row])
        }
    }
    
    func toggleFilter(filters: NSMutableArray, object: String) {
        if filters.containsObject(object) {
            filters.removeObject(object)
        } else {
            filters.addObject(object)
        }
    }
}