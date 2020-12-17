//
//  doneButton.swift
//  Traffic
//
//  Created by 김민국 on 2017. 7. 29..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit

@IBDesignable class doneButton: UIButton {

    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = (UIColor(red: 255/255, green: 132/255, blue: 102/255, alpha: 1) as! CGColor)
    }
}
