//
//  VALBasicInfoCell.swift
//  Vallient
//
//  Created by Anthony Williams on 7/5/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit

class VALBasicInfoCell: UITableViewCell {
    
    var logoImageView: UIImageView!
    var nameLabel: UILabel!
    var addressLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 80)
        
        setupCell()
    }
    
    func setupCell() {
        logoImageView = UIImageView(frame: CGRectMake(10, 5, bounds.maxY-10, bounds.maxY-10))
        logoImageView.contentMode = .ScaleAspectFit
        logoImageView.layer.masksToBounds = true
        logoImageView.clipsToBounds = true
        logoImageView.autoresizingMask = .None
        addSubview(logoImageView)
        
        nameLabel = UILabel(frame: CGRectMake(logoImageView.frame.maxX+10, 5, frame.size.width, 28))
        nameLabel.textColor = UIColor.vallientTextColor()
        nameLabel.textAlignment = .Left
        nameLabel.font = UIFont(name: "Helvetica", size: 24)
        nameLabel.numberOfLines = 0
        addSubview(nameLabel)
        
        addressLabel = UILabel(frame: CGRectMake(nameLabel.frame.minX, nameLabel.frame.maxY, nameLabel.frame.size.width, 42))
        addressLabel.textColor = UIColor.vallientTextColor()
        addressLabel.textAlignment = .Left
        addressLabel.font = UIFont(name: "Helvetica-Light", size: 14)
        addressLabel.numberOfLines = 0
        addSubview(addressLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
