//
//  VALEventTableViewCell.swift
//  Vallient
//
//  Created by Anthony Williams on 7/16/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit

class VALEventTableViewCell: UITableViewCell {


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 80)
        
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        
    }

}
