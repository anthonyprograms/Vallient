//
//  VALTableView.swift
//  Vallient
//
//  Created by Anthony Williams on 6/18/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit

class VALTableView: UITableView, UITableViewDelegate {
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event)
        if (point.y < 0){
            return nil
        }
        return hitView
    }
    
}