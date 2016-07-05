//
//  VALCompanyImageCell.swift
//  Vallient
//
//  Created by Anthony Williams on 6/18/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit

class VALCompanyImageCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.center.x = self.bounds.width/2
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(imageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
