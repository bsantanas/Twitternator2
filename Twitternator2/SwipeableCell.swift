//
//  SwipeableCell.swift
//  Twitternator2
//
//  Created by Bernardo Santana on 9/8/15.
//  Copyright (c) 2015 Bernardo Santana. All rights reserved.
//

import UIKit

class SwipeableCell: UITableViewCell {
    
    @IBOutlet weak var childContentView: UIView!
    var initialFrame:CGRect?
    var startingRightLayoutConstraintConstant: CGFloat?
    var panStartPoint:CGPoint?
    var viewStartPoint:CGPoint?
    weak var delegate: SwipeCellDelegate?
    
    // For table view referencing
    var identifier:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let pan = UIPanGestureRecognizer(target: self, action: "panContentView:")
        pan.delegate = self
        childContentView.addGestureRecognizer(pan)
        self.backgroundColor = .clearColor()
    }
    
    func panContentView(pan:UIPanGestureRecognizer) {
        switch pan.state {
            
        case .Began:
            //contentView.layer.removeAllAnimations()
            panStartPoint = pan.locationInView(contentView)
            viewStartPoint = childContentView.center
            initialFrame = childContentView.frame
            
        case .Changed:
            let deltaX = pan.locationInView(contentView).x - panStartPoint!.x
            let y = childContentView.bounds.midY
            childContentView.center = CGPoint(x: viewStartPoint!.x + deltaX, y: y)
            
        case .Ended:
            let invOffset = childContentView.frame.width - childContentView.frame.origin.x
            var center = contentView.center
            var remove = false
            var duration:NSTimeInterval = 1
            
            if invOffset < 100 { // pulled to the right
                center.x = contentView.frame.width * 2 // remove from screen
                remove = true
                duration = 0.4
            }
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: nil, animations: {
                
                self.childContentView.center = center
                
                }, completion: { value in
                    if remove {
                        self.delegate?.removeCellWithID(self.identifier!)
                        self.childContentView.hidden = true
                        self.childContentView.frame = self.initialFrame!
                    }
            })
            
        default:
            // Cancelled
            println("Gesture recognizer was cancelled")
        }
    }
    
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

protocol SwipeCellDelegate: class {
    func removeCellWithID(identifier:String)
}
