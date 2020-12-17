//
//  MenuTabBarViewController.swift
//  Traffic
//
//  Created by 김민국 on 2017. 8. 17..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit

class MenuTabBarViewController: UITabBarController {

    
    let customTabBarView = UIView()
    let tabBtn01 = UIButton()
    let tabBtn02 = UIButton()
    let tabBtn03 = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.isHidden = true
        
        customTabBarView.frame = CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: 60)
        
        let nonimage = UIImage(named: "tabbarback")
        let backImage:UIImage = resized(image: nonimage!, newSize: CGSize(width: customTabBarView.frame.width, height: customTabBarView.frame.height))
        let backgroundImg = UIImageView(image: backImage)
        
        customTabBarView.addSubview(backgroundImg)
        
        let widthofOneBtn = self.tabBar.frame.size.width/3
        let heightofOneBtn = self.customTabBarView.frame.height
        
        tabBtn01.frame = CGRect(x: 0, y: 0, width: widthofOneBtn, height: heightofOneBtn)
        tabBtn02.frame = CGRect(x: widthofOneBtn, y: 0, width: widthofOneBtn, height: heightofOneBtn)
        tabBtn03.frame = CGRect(x: widthofOneBtn+widthofOneBtn, y: 0, width: widthofOneBtn, height: heightofOneBtn)
        
        tabBtn01.setTitle("정보", for: UIControlState.normal)
        tabBtn02.setTitle("리뷰", for: UIControlState.normal)
        tabBtn03.setTitle("대기열", for: UIControlState.normal)
        
        tabBtn01.tag = 0
        tabBtn02.tag = 1
        tabBtn03.tag = 2

        setAttributeTabBarButton(btn: tabBtn01)
        setAttributeTabBarButton(btn: tabBtn02)
        setAttributeTabBarButton(btn: tabBtn03)
        self.tabBtn01.isSelected = true
        
        self.view.addSubview(customTabBarView)
    }
    
    func setAttributeTabBarButton(btn : UIButton)
    {
        btn.addTarget(self, action: #selector(onBtnClick(sender: )), for: UIControlEvents.touchUpInside)
        btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn.setTitleColor(UIColor.green, for: UIControlState.selected)
        self.customTabBarView.addSubview(btn)
    }
    
    @objc func onBtnClick(sender: UIButton)
    {
        self.tabBtn01.isSelected = false
        self.tabBtn02.isSelected = false
        self.tabBtn03.isSelected = false
        
        sender.isSelected = true
        
        self.selectedIndex = sender.tag
    }
    func resized(image:UIImage ,newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

