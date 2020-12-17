//
//  UserOptionViewController.swift
//  Traffic
//
//  Created by 김민국 on 2017. 7. 19..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit

class UserOptionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "기본 바탕")!
        
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(image, for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func gohome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
