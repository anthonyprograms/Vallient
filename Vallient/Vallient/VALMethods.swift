//
//  VALMethods.swift
//  Vallient
//
//  Created by Anthony Williams on 7/16/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import MapKit

class VALMethods: NSObject {

    class func mapToLocation(name: String, coordinates: CLLocationCoordinate2D){
        let regionDistance:CLLocationDistance = 10000
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    class func shareSheet(url: String, viewController: UIViewController) {
        let firstActivityItem = "Vallient Event:"
        let secondActivityItem : NSURL = NSURL(string: url)!
        // If you want to put an image
        let image : UIImage = UIImage(named: "vallient.png")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
                
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityTypePostToWeibo,
            UIActivityTypePrint,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo
        ]
        
        viewController.presentViewController(activityViewController, animated: true, completion: nil)
    }
}
