//
//  VALFilterCollectionViewCell.swift
//  Vallient
//
//  Created by Anthony Williams on 6/26/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit

class VALFilterCollectionViewCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    var checkmarkLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel(frame: self.bounds)
        titleLabel.font = UIFont(name: "Helvetica", size: 14)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(titleLabel)
        
        initCheckmark()
    }
    
    // TODO: Create checkmark for custom cell (hide) .. on selection unhide
    func initCheckmark() {
        checkmarkLayer = CAShapeLayer()
        
        // Draw checkmark
        let checkmarkPath = UIBezierPath()
        checkmarkPath.moveToPoint(CGPointMake(8, 45))
        checkmarkPath.addLineToPoint(CGPointMake(20, 60))
        checkmarkPath.addLineToPoint(CGPointMake(60, 15))
        checkmarkPath.lineWidth = 5.0
        checkmarkLayer.strokeColor = UIColor.greenColor().CGColor
        checkmarkLayer.fillColor = UIColor.clearColor().CGColor
        checkmarkLayer.path = checkmarkPath.CGPath
        
        self.layer.addSublayer(checkmarkLayer)
        
        checkmarkLayer.hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
