//
//  homeTopCorner.swift
//  Traffic
//
//  Created by 김민국 on 2017. 7. 31..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit

@IBDesignable class homeTopCorner: UIView {

    var view: UIView!
    
    @IBInspectable
    var bordercorner: CGFloat = 0{
        didSet{
            layer.cornerRadius = bordercorner
        }
    }
}
