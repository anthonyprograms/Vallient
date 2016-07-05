//
//  VALCompanyDetailView.swift
//  Vallient
//
//  Created by Anthony Williams on 6/18/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

protocol VALCompanyDetailViewDelegate {
    func openWebSite(website: String)
    func closeCompanyDetailView()
    func relatedCompanySelected(company: NSDictionary)
}

class VALCompanyDetailView: UIView {

    var managedContext: NSManagedObjectContext!
    var company: NSDictionary!
    var name: String = ""
    var info: String = ""
    var imageUrl: String = ""
    var address: String = ""
    var coordinates: CLLocationCoordinate2D!
    var site: String = ""
    
    var relatedCompanies: [NSDictionary]!
    
    var delegate: VALCompanyDetailViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    init(frame: CGRect, company: NSDictionary, relatedCompanies: [NSDictionary]) {
        super.init(frame: frame)
        
        self.relatedCompanies = relatedCompanies
        self.company = company
        
        self.name = "\(company["name"]!)"
        self.info = "\(company["info"]!)"
        self.imageUrl = "\(company["imageUrl"]!)"
        self.address = "\(company["address"]!)"
        self.site = "\(company["site"]!)"
        
        if let latitude = company["latitude"] as? NSNumber {
            if let longitude = company["longitude"] as? NSNumber {
                self.coordinates = CLLocationCoordinate2DMake(Double(latitude), Double(longitude))
            }
        }
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurView.frame = CGRectMake(0, 0, self.frame.size.width-40, 2*self.frame.size.height/3)
        blurView.center = self.center
        blurView.layer.cornerRadius = 18.0
        blurView.layer.masksToBounds = true
        self.addSubview(blurView)
        
        let tableView = UITableView(frame: blurView.bounds)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.clearColor()
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        blurView.addSubview(tableView)
        
        let closeButton = UIButton(frame: CGRectMake(blurView.frame.maxX-25.0, blurView.frame.origin.y-20, 40, 40))
        closeButton.setTitle("X", forState: .Normal)
        closeButton.titleLabel?.textColor = .whiteColor()
        closeButton.titleLabel?.font = UIFont(name: "Helvetica", size: 26)
        closeButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        closeButton.layer.cornerRadius = closeButton.frame.height/2
        closeButton.layer.masksToBounds = true
        closeButton.addTarget(self, action: #selector(VALCompanyDetailView.close), forControlEvents: .TouchUpInside)
        self.addSubview(closeButton)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(90, 90)
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 0.0
        
        let collectionViewFrame = CGRectMake(0, blurView.frame.origin.y+blurView.frame.height, self.frame.width, self.frame.maxY - blurView.frame.maxY)
        let collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(VALRelatedCompanyCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
        collectionView.backgroundColor = UIColor.clearColor()
        self.addSubview(collectionView)
    }
    
    func close() {
        delegate?.closeCompanyDetailView()
        self.removeFromSuperview()
    }
    
    func mapToLocation(){
        let regionDistance:CLLocationDistance = 10000
        let regionSpan = MKCoordinateRegionMakeWithDistance(self.coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: self.coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.name
        mapItem.openInMapsWithLaunchOptions(options)
    }
}

extension VALCompanyDetailView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell: VALCompanyImageCell! = tableView.dequeueReusableCellWithIdentifier("ImageCell") as? VALCompanyImageCell
            if cell == nil {
                cell = tableView.dequeueReusableCellWithIdentifier("ImageCell") as? VALCompanyImageCell
                cell = VALCompanyImageCell(style: .Default, reuseIdentifier: "ImageCell")
            }
            
            if let url = NSURL(string: imageUrl) {
                cell.imageView?.kf_setImageWithURL(url, placeholderImage: nil)
            }
            
            cell.backgroundColor = .clearColor()
            cell.selectionStyle = .None
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            
            cell.imageView?.image = nil
            cell.textLabel?.font = UIFont(name: "Helvetica", size: 16)
            cell.backgroundColor = .clearColor()
            cell.textLabel?.textColor = .whiteColor()
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .None
            
            if indexPath.row == 1 {
                cell.textLabel?.text = name
                cell.textLabel?.font = UIFont(name: "Helvetica", size: 32)
            } else if indexPath.row == 2 {
                cell.textLabel?.text = site
                cell.textLabel?.font = UIFont(name: "Helvetica", size: 20)
                cell.textLabel?.textColor = UIColor(red: 63/255, green: 91/255, blue: 225/255, alpha: 1)
            } else if indexPath.row == 3 {
                cell.textLabel?.text = address
            } else if indexPath.row == 4 {
                cell.textLabel?.text = info
            } else if indexPath.row == 5 {
                cell.textLabel?.text = "Go"
                cell.backgroundColor = UIColor(red: 61/255, green: 219/255, blue: 91/255, alpha: 1)
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {        
        return 25
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            print("Full screen image")
        } else if indexPath.row == 2 {
            delegate?.openWebSite(site)
        } else if indexPath.row == 5 {
            self.mapToLocation()
        }
    }
}

extension VALCompanyDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedCompanies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! VALRelatedCompanyCollectionViewCell
        
        cell.layer.cornerRadius = 8.0
        cell.layer.masksToBounds = true
        if let url = NSURL(string: relatedCompanies[indexPath.row]["imageUrl"] as! String) {
            cell.imageView.kf_setImageWithURL(url, placeholderImage: nil)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.relatedCompanySelected(relatedCompanies[indexPath.row])
        removeFromSuperview()
    }
}
