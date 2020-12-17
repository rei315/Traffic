//
//  CategoryViewController.swift
//  Traffic
//
//  Created by 김민국 on 2017. 7. 19..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import CoreLocation
import MapKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var indiview: UIView!
    @IBOutlet weak var indi: UIActivityIndicatorView!

    var kindTag:Int = 0
    var trafTag:Int = 0
    var distTag:Int = 0
    
    var kindpicks = ["전체","음식점","카페"]
    var trafficpicks = ["전체","쾌적","원활","혼잡"]
    var distancepicks = ["전체","300m","500m","1km"]
    var intdistance = [0, 300, 500, 1000]
    
    var refHandle: UInt!
    var ref: DatabaseReference!
    
    var UserList = [Userdata]()
    var filterList = [Userdata]()
    
    var userListCount:Int = 0
    
    var mylocal = CLLocation()
    var mylatitude:Double = 0.0
    var mylongitude:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        mylatitude = defaults.double(forKey: "myLatitude")
        mylongitude = defaults.double(forKey: "myLongitude")
        
        mylocal = CLLocation(latitude: mylatitude, longitude: mylongitude)
        
        ref = Database.database().reference()
    
        doneButton.layer.cornerRadius = 5


    }
    override func viewDidAppear(_ animated: Bool) {
        fetchUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Gohome(_ sender: Any) {
        if indiview.isHidden == true{
            dismiss(animated: true, completion: nil)
        }
    }

    func fetchUsers(){
        
        indiview.isHidden = false
        indi.startAnimating()
        
        UserList.removeAll()
        
        refHandle = ref.child("Users").observe(.childAdded, with: { (snapshot) in
            
            self.userListCount = snapshot.children.allObjects.count
            
            for snap in snapshot.children.allObjects as! [DataSnapshot]{
                let dictionary = snap.value as? [String : Any]
                
                
                let getname = dictionary?["myname"]
                let getaddress = dictionary?["myaddress"]
                let getaccount = dictionary?["myaccount"]
                let getlang = dictionary?["mylatitude"]
                let getlong = dictionary?["mylongitude"]
                let getcategory = dictionary?["mycategory"]
                let getnow = dictionary?["now"]
                
                let post = Userdata(name: getname as? String, address: getaddress as? String, account: getaccount as? String, latitude: getlang as? Double, longitude: getlong as? Double, category: getcategory as? String, now: getnow as? String)
                
                self.UserList.append(post)
                
                if self.UserList.count == self.userListCount{
                    if self.indiview.isHidden == false && self.indi.isAnimating == true{
                        self.indi.stopAnimating()
                        self.indiview.isHidden = true
                    }
                }
            }
        }, withCancel: nil)
    }
    
    @IBAction func kindPick(_ sender: CustomSeguementedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            kindTag = 0
            break
        case 1:
            kindTag = 1
            break
        case 2:
            kindTag = 2
            break
        default:
            trafTag = 0
            break
        }
    }
    
    @IBAction func trafficPick(_ sender: CustomSeguementedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            trafTag = 0
            break
        case 1:
            trafTag = 1
            break
        case 2:
            trafTag = 2
            break
        case 3:
            trafTag = 3
            break
        default:
            trafTag = 0
            break
        }
    }
    
    @IBAction func distancePick(_ sender: CustomSeguementedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            distTag = 0
            break
        case 1:
            distTag = 1
            break
        case 2:
            distTag = 2
            break
        case 3:
            distTag = 3
            break
        default:
            break
        }
    }
    

    @IBAction func Done(_ sender: Any) {
        if indiview.isHidden == true && indi.isAnimating == false{
            indiview.isHidden = false
            indi.startAnimating()
        }
        if kindTag == 0{
            filterList = UserList
        }else if kindTag == 1{
            filterList = UserList.filter{($0.mycategory?.contains(kindpicks[1]))!}
        }else if kindTag == 2{
            filterList = UserList.filter{($0.mycategory?.contains(kindpicks[2]))!}
        }
        
        if trafTag == 0{
            
        }else if trafTag == 1{
            filterList = filterList.filter{($0.mynow?.contains(trafficpicks[1]))!}
        }else if trafTag == 2{
            filterList = filterList.filter{($0.mynow?.contains(trafficpicks[2]))!}
        }else if trafTag == 3{
            filterList = filterList.filter{($0.mynow?.contains(trafficpicks[3]))!}
        }
        
        if distTag == 0{
            
        }else if distTag == 1{
            filterList = filterList.filter{Int(CLLocation(latitude: $0.mylatitude!,longitude: $0.mylongitude!).distance(from: mylocal)) <= intdistance[1]}
        }else if distTag == 2{
            filterList = filterList.filter{Int(CLLocation(latitude: $0.mylatitude!,longitude: $0.mylongitude!).distance(from: mylocal)) <= intdistance[2]}
        }else if distTag == 3{
            filterList = filterList.filter{Int(CLLocation(latitude: $0.mylatitude!,longitude: $0.mylongitude!).distance(from: mylocal)) <= intdistance[3]}
        }
        
        if indiview.isHidden == false && indi.isAnimating == true{
            indi.stopAnimating()
            indiview.isHidden = true
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "filterview"){
            let navVc = segue.destination as! UINavigationController
            let chatVc = navVc.viewControllers.first as! UserMapList
            
            
            if kindTag != 0 || distTag != 0 || trafTag != 0{
                chatVc.filterList.removeAll()
                chatVc.filterList = filterList
            }else{
                chatVc.userList.removeAll()
                chatVc.userList = filterList
            }
            chatVc.getkindTag = kindTag
            chatVc.gettrafTag = trafTag
            chatVc.getdistTag = distTag
        }
    }
}
