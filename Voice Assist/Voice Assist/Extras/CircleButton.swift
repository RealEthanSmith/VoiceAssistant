//
//  CircleButton.swift
//  Voice Assist
//
//  Created by Emmett Shaughnessy on 4/17/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.
//

import UIKit
@IBDesignable

class CircleButton: UIButton {

    @IBInspectable var CornerRadius: CGFloat = 30.0 {
        didSet{
            setupView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    
    func setupView(){
        layer.cornerRadius = CornerRadius
    }
}
