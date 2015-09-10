//
//  SwipeableCell.swift
//  Twitternator2
//
//  Created by Bernardo Santana on 9/8/15.
//  Copyright (c) 2015 Bernardo Santana. All rights reserved.
//

import UIKit
import TwitterKit

class SwipeableCell: TWTRTweetTableViewCell {
    // For table view referencing
    var identifier:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .clearColor()
        self.backgroundColor = .clearColor()
    }
 
}

