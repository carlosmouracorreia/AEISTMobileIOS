//
//  RatingControl.swift
//  AEISTMobile
//
//  Created by Carlos Correia on 04/09/15.
//  Copyright © 2015 AEIST. All rights reserved.
//

import UIKit

class RatingControl: UIView {
    // MARK: Properties
    var spacing = 5
    var stars = 5
    var rating = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    //called immediately after rating is set -> setNeedsLayout() -> triggers layout update
    
    var ratingButtons = [UIButton]()

   // MARK: Initialization
    
    //view is initialized here
    override func layoutSubviews() {
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        // Offset each button's origin by the length of the button plus spacing.
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
        //It’s important to update the button selection states when the view loads, not just when the rating changes.
        updateButtonSelectionStates()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")
        // _ means wildcard. its like a foreach in php (dont need to know the index)
        for _ in 0..<stars {
            let button = UIButton()
            
            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
            
            button.adjustsImageWhenHighlighted = false
            
            button.addTarget(self, action: "ratingButtonTapped:", forControlEvents: .TouchDown)
            ratingButtons += [button]
            addSubview(button)
        }
    }
    
    // MARK: Button Action
    func ratingButtonTapped(button: UIButton) {
        rating = ratingButtons.indexOf(button)! + 1
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerate() {
            // If the index of a button is less than the rating, that button should be selected.
            button.selected = index < rating
        }
    }
}
