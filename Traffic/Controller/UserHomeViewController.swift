//
//  UserHomeViewController.swift
//  Traffic
//
//  Created by 김민국 on 2017. 7. 19..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class UserHomeViewController: UIViewController,dataSentDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var LocationText: UITextField!
    
    var myaddress:String = ""
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: LocationText.frame.height))
        LocationText.leftView = paddingView
        LocationText.leftViewMode = UITextFieldViewMode.always
        
        if LocationText.text == ""{
            let test = UserDefaults.standard
            myaddress = test.string(forKey: "myLocation") ?? "위치 검색을 해주세요"
            LocationText.text = myaddress
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendlocation"{
            let navVc = segue.destination as! UINavigationController
            let chatVc = navVc.viewControllers.first as! UserHomeLocationViewController
            chatVc.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if LocationText.text == ""
        {
            LocationText.text = "위치 검색을 다시 해주세요"
        }
    }
    @IBAction func search(_ sender: Any) {
        if LocationText.text?.isEmpty != true && LocationText.text != "위치 검색을 다시 해주세요" && LocationText.text != "위치 검색을 해주세요"{
            performSegue(withIdentifier: "search", sender: AnyObject.self)
        }
    }
    @IBAction func getAll(_ sender: Any) {
        if LocationText.text?.isEmpty != true && LocationText.text != "위치 검색을 다시 해주세요" && LocationText.text != "위치 검색을 해주세요"{
            performSegue(withIdentifier: "getAll", sender: AnyObject.self)
        }
    }
    

    func sendLocation(data: String) {
        LocationText.text = data
    }
}

