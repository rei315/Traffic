//
//  GetTrafficForUser.swift
//  Traffic
//
//  Created by 김민국 on 2017. 6. 26..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class GetTrafficForUser: UIViewController {
    
    var ref: DatabaseReference!
    var post = [String:AnyObject]()
    var cnt: Int = 3
    
    var databaseHandle:DatabaseHandle?
    
    let red = UIImage(named:"red.png")
    let orange = UIImage(named:"orrange.png")
    let green = UIImage(named:"green.png")
    let userID = Auth.auth().currentUser?.uid
    var ID:String = ""
    var getID:String = ""
    
    override func viewDidLoad() {
        
        ref = Database.database().reference()
        let image = UIImage(named: "기본 바탕")!
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(image, for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
        }
        
        super.viewDidLoad()
    }

    @IBAction func Gohome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
