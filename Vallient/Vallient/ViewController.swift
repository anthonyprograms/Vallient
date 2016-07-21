//
//  ViewController.swift
//  Vallient
//
//  Created by Anthony Williams on 6/18/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import MapKit
import Haneke
import Kingfisher
import SafariServices
import CoreData
import MessageUI

class ViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView! = UIActivityIndicatorView()
    
    var tableView: VALTableView! = VALTableView()
    let mapView: MKMapView! = MKMapView()
    var companies: [NSDictionary] = []
    var cityFilters: NSMutableArray! = []
    var valuationFilters: NSMutableArray! = []
    var statusFilters: NSMutableArray! = []
    
    var regionCenter = CLLocationCoordinate2DMake(37.7759, -122.4125)
    var regionSpan = MKCoordinateSpanMake(4/69.0, 4/69.0)
    
    var managedContext: NSManagedObjectContext!
    var madeNetworkRequest = false
    
    var companyCache: VALCompanyCache!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        companyCache = VALCompanyCache(managedContext: managedContext)
        
        if !madeNetworkRequest {
            VALHTTPClient().getCompanies { data in
                if let companies = data as? [NSDictionary] {
                    self.companyCache.emptyCoreData()
                    self.companyCache.saveCompany(companies)
                    
                    self.getCompaniesAndUpdateView()
                    
                    self.madeNetworkRequest = true
                }
            }
        } else {
            self.getCompaniesAndUpdateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.vallientPrimaryColor()
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        initNavigationItemTitleView()
        
//        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
//        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        activityIndicator.center = view.center
//        activityIndicator.color = UIColor(red: 25/255, green: 201/255, blue: 108/255, alpha: 1)
//        view.addSubview(activityIndicator)
        
        let filterButton = UIBarButtonItem(title: "Filter", style: .Done, target: self, action: #selector(ViewController.filterCompanies))
        self.navigationItem.leftBarButtonItem = filterButton
        
        let submitButton = UIBarButtonItem(title: "Submit", style: .Done, target: self, action: #selector(ViewController.submitAction))
        self.navigationItem.rightBarButtonItem = submitButton
//        activityIndicator.startAnimating()
        
        
        mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        mapView.setRegion(MKCoordinateRegion(center: regionCenter, span: regionSpan), animated: false)
        mapView.delegate = self
//        activityIndicator.stopAnimating()
        view.addSubview(mapView)
        
        let tableViewPopUpButton = UIButton(frame: CGRectMake(0, mapView.frame.height-40, view.frame.size.width, 40))
        tableViewPopUpButton.backgroundColor = .clearColor()
        tableViewPopUpButton.setTitle("Up", forState: .Normal)
        tableViewPopUpButton.titleLabel?.font = UIFont(name: "Helvetica", size: 22)
        tableViewPopUpButton.setTitleColor(.blackColor(), forState: .Normal)
        tableViewPopUpButton.addTarget(self, action: #selector(ViewController.popUpTableView), forControlEvents: .TouchUpInside)
        view.addSubview(tableViewPopUpButton)
    
        tableView.frame = view.bounds
        tableView.registerClass(VALBasicInfoCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.clearColor()
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        UIView.animateWithDuration(0.7) {
            self.tableView.contentInset = UIEdgeInsetsMake(self.mapView.frame.size.height, 0, 0, 0)
        }
    }
    
    private func initNavigationItemTitleView() {
        let titleView = UILabel()
        titleView.text = "Vallient"
        titleView.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        
        let width = titleView.sizeThatFits(CGSizeMake(CGFloat.max, CGFloat.max)).width
        titleView.frame = CGRect(origin:CGPointZero, size:CGSizeMake(width, 500))
        self.navigationItem.titleView = titleView
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.titleWasTapped))
        titleView.userInteractionEnabled = true
        titleView.addGestureRecognizer(recognizer)
    }
    
    func titleWasTapped() {
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
    }
    
    @objc private func filterCompanies() {
        let filterViewController = VALFilterViewController()
        
        mapView.removeAnnotations(mapView.annotations)
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }
    
    func popUpTableView() {
        var row: Int
        if self.companies.count < 5 {
            row = self.companies.count-1
        } else {
            row = 5
        }
        
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }
    
    func getCompaniesAndUpdateView() {
        if let companyData = self.companyCache.getCompanies(regionCenter, span: regionSpan) {
            self.companies = companyData
            self.tableView.reloadData()

            dispatch_async(dispatch_get_main_queue()) {
                self.annotateMap(companyData)
            }
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < mapView.frame.size.height * -1) {
            scrollView.setContentOffset(CGPointMake(scrollView.contentOffset.x, mapView.frame.size.height * -1), animated: true)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: VALBasicInfoCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! VALBasicInfoCell
        cell = VALBasicInfoCell(style: .Default, reuseIdentifier: "Cell")
        
        cell.nameLabel.text = "\(companies[indexPath.row]["name"]!)"
        cell.addressLabel.text = "\(companies[indexPath.row]["address"]!)"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if let imageUrl = self.companies[indexPath.row]["imageUrl"] as? String {
                if let url = NSURL(string: imageUrl) {
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.logoImageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "vallient.png"))
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let name = companies[indexPath.row]["name"] as? String {
            if let tag = companies[indexPath.row]["tag"] as? String {
                if let relatedCompanies = companyCache.getRelatedCompanies(name, companyTag: tag) {
                    let companyDetailView = VALCompanyDetailView(frame: view.bounds, company: companies[indexPath.row], relatedCompanies: relatedCompanies)
                    companyDetailView.center = view.center
                    companyDetailView.delegate = self
                    view.addSubview(companyDetailView)
                    
                    self.navigationController?.navigationBarHidden = true
                }
            }
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func annotateMap(data: [NSDictionary]) {
        for item in data {
            let annotation = VALMapAnnotation(company: item)
            
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = "AnnotationIdentifier"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            pinView?.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.InfoLight)
        } else {
            pinView!.annotation = annotation
        }
        
        if annotation is VALMapAnnotation {
            let valAnnotation = annotation as! VALMapAnnotation
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let url = NSURL(string: valAnnotation.company["imageUrl"] as! String)
                let data = NSData(contentsOfURL: url!)
                pinView!.image = UIImage(data: data!)
                
                // Resize image
                let pinImage = UIImage(data: data!)
                let size = CGSize(width: 35, height: 35)
                UIGraphicsBeginImageContext(size)
                pinImage!.drawInRect(CGRectMake(0, 0, size.width, size.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                dispatch_async(dispatch_get_main_queue()) {
                    pinView!.image = resizedImage
                }
            }
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! VALMapAnnotation

        if let name = annotation.title {
            if let tag = annotation.company["tag"] as? String {
                if let relatedCompanies = companyCache.getRelatedCompanies(name, companyTag: tag) {
                    let companyDetailView = VALCompanyDetailView(frame: self.view.bounds, company: annotation.company, relatedCompanies: relatedCompanies)
                    companyDetailView.center = self.view.center
                    companyDetailView.delegate = self
                    self.view.addSubview(companyDetailView)
                    self.navigationController?.navigationBarHidden = true
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        regionCenter = mapView.region.center
        regionSpan = mapView.region.span
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(ViewController.getCompaniesAndUpdateView), userInfo: nil, repeats: false)
        timer.fire()
        
//        self.getCompaniesAndUpdateView()
    }
}

extension ViewController: VALCompanyDetailViewDelegate {
    func openWebSite(website: String) {
        openSafariViewController(website)
    }
    
    func closeCompanyDetailView() {
        self.navigationController?.navigationBarHidden = false
    }
    
    func relatedCompanySelected(company: NSDictionary) {
        if let name = company["name"] as? String {
            if let tag = company["tag"] as? String {
                if let relatedCompanies = companyCache.getRelatedCompanies(name, companyTag: tag) {
                    let companyDetailView = VALCompanyDetailView(frame: view.bounds, company: company, relatedCompanies: relatedCompanies)
                    companyDetailView.center = view.center
                    companyDetailView.delegate = self
                    view.addSubview(companyDetailView)
                }
            }
        }
    }
    
    func showCompanyEvents(name: String) {
        let companyEventsViewController = VALCompanyEventsViewController(companyName: name)
        companyEventsViewController.managedContext = self.managedContext
        
        self.navigationController?.pushViewController(companyEventsViewController, animated: true)
    }
}

extension ViewController: SFSafariViewControllerDelegate {
    func openSafariViewController(site: String) {
        let safariViewController = SFSafariViewController(URL: NSURL(string: site)!)
        safariViewController.delegate = self
        self.presentViewController(safariViewController, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    func submitAction() {
        let emailTitle = "Submission"
        let messageBody = "I have a company and/or event I want to be added:"
        let toRecipents = ["anthonygreen274@gmail.com"]
        
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result {
        case MFMailComposeResultCancelled:
            print("Mail cancelled")
        case MFMailComposeResultSaved:
            print("Mail saved")
        case MFMailComposeResultSent:
            print("Mail sent")
        case MFMailComposeResultFailed:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
