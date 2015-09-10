//
//  CustomTextfield.swift
//  Twitternator2
//
//  Created by Bernardo Santana on 9/9/15.
//  Copyright (c) 2015 Bernardo Santana. All rights reserved.
//

import UIKit

class CustomTextfield: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 0
        layer.masksToBounds = true
        layer.borderColor = UIColor.clearColor().CGColor
        layer.borderWidth = 0
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 0;
        self.layer.borderColor = UIColor.clearColor().CGColor
        self.layer.borderWidth = 0
        self.borderStyle = .None
        let color = UIColor.grayColor()
        let customPlaceholder = NSAttributedString(string: "#StartHere", attributes: [NSForegroundColorAttributeName:color])
        self.attributedPlaceholder = customPlaceholder
    }

}
