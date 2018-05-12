//
//  CircleButton.swift
//  MajanCamera
//
//  Created by Syunyo Kawamoto on 2018/05/12.
//  Copyright © 2018年 Syunyo Kawamoto. All rights reserved.
//

import UIKit

class CircleButton: UIButton {

    @IBInspectable var textColor: UIColor?
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
}


