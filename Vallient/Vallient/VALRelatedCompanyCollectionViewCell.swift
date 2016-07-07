//
//  VALRelatedCompanyCollectionViewCell.swift
//  Vallient
//
//  Created by Anthony Williams on 7/4/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit

class VALRelatedCompanyCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: self.bounds)
        contentView.addSubview(imageView)
    }
    
    init(frame: CGRect, imageUrl: String) {
        super.init(frame: frame)
        
        setupCell(imageUrl)
    }
    
    func setupCell(imageUrl: String) {
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .ScaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.autoresizingMask = .None
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
