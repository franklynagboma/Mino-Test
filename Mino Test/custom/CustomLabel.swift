//
//  CustomLabel.swift
//  Mino Test
//
//  Created by Franklyn AGBOMA on 09/10/2019.
//  Copyright © 2019 Frankyn AGBOMA. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    
    //When used in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCustomLabel()
    }
    
    //When used in storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpCustomLabel()
    }
    
    private func setUpCustomLabel() {
        
        font = UIFont(name: "Futura", size: 12)
        layer.cornerRadius = 15
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    func setTextTitleAndColor(lebelTitle: String, labelColor : UIColor, groundColor : UIColor?) {
        if !lebelTitle.isEmpty {
            text = lebelTitle
        }
        if let viewColor = groundColor {
            backgroundColor = viewColor
            textColor = labelColor
        }
    }
}
