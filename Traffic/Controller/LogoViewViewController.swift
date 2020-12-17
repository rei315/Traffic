//
//  LogoViewViewController.swift
//  Traffic
//
//  Created by 김민국 on 2017. 7. 4..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit

class LogoViewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + .seconds(2)
        mainQueue.asyncAfter(deadline: deadline) {
            self.gonext()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gonext(){
        performSegue(withIdentifier: "gonext", sender: self)
        //UIStoryboardSegue.perform
    }
    
    
    
}
