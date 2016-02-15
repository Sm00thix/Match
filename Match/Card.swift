//
//  Card.swift
//  Match
//
//  Created by Ole Engstrøm on 10/11/15.
//  Copyright © 2015 Ole Engstroem. All rights reserved.
//

import UIKit

class Card: UIView {
    
    var frontImageView:UIImageView = UIImageView()
    var backImageView:UIImageView = UIImageView()
    var cardValue:Int = 0
    var cardNames:[String] = ["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9", "card10", "card11", "card12", "card13"]
    
    var isDone:Bool = false {
        
        didSet {
            // If the card is done, then remove the image
            if isDone == true {
                
                UIView.animateWithDuration(1, delay: 1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    
                    self.frontImageView.alpha = 0
                    self.backImageView.alpha = 0
                    
                    }, completion: nil)

            }
        }
    }
    
    var isFlipped:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // set default image for the imageview
        self.backImageView.image = UIImage(named: "back")
        self.applySizeConstraintToImage(self.backImageView)
        self.applyPositioningConstraintsToImage(self.backImageView)
        
        // set autolayout constraints for the front
        self.applySizeConstraintToImage(self.frontImageView)
        self.applyPositioningConstraintsToImage(self.frontImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    func applySizeConstraintToImage(imageView:UIImageView) {
        
        // Set translates autoresizingmask to false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // add the imageview to the view
        self.addSubview(imageView)
        
        // set constrains for the imageview
        let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 170)
        
        let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 120)
        
        imageView.addConstraints([heightConstraint, widthConstraint])
        
    }
    
    func applyPositioningConstraintsToImage(imageView:UIImageView) {
        
        // Set the position of the image view
        
        let verticalConstraint:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        let horizontalConstraint:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        self.addConstraints([verticalConstraint, horizontalConstraint])
    }
    
    func flipUp() {
        // Set imageview to image that represents the card value
        self.frontImageView.image = UIImage(named: self.cardNames[self.cardValue])
        
        // Do animations
        UIView.transitionFromView(self.backImageView, toView: self.frontImageView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
        
        // Add positioning constraints
        self.applyPositioningConstraintsToImage(frontImageView)
        
        self.isFlipped = true
    }
    
    func flipDown() {
        
        UIView.transitionFromView(self.frontImageView, toView: self.backImageView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        
        // Add positioning constraints
        self.applyPositioningConstraintsToImage(self.backImageView)
        
        self.isFlipped = false
    }
}
