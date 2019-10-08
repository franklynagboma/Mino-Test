//
//  CustomButton.swift
//  Mino Test
//
//  Created by Franklyn AGBOMA on 08/10/2019.
//  Copyright © 2019 Frankyn AGBOMA. All rights reserved.
//

import UIKit

class CustomButton : UIButton {
    
    //When custom button is used as code directly
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCustomButton()
    }
    
    //When custom button is used in storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpCustomButton()
    }
    
    
    func setUpCustomButton() {
        setShadow()
        
        titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        layer.cornerRadius = 25
        layer.borderWidth = 3.0
        layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func setButtonTitleAndColor(buttonName : String?, titleColor : UIColor, baseColor : UIColor) {
        if let name = buttonName{
            setTitle(name, for: .normal)
        }
        backgroundColor = baseColor
        setTitleColor(titleColor, for: .normal)
    }
    
    
    private func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    func shakeButton() {
        let shake  = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 8, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 8, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}
