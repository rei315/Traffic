//
//  Traffic.swift
//  Traffic
//
//  Created by 김민국 on 2017. 6. 25..
//  Copyright © 2017년 김민국. All rights reserved.
//
import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import CoreData


class Traffic: UIViewController {

    
    @IBOutlet weak var redOn: UIImageView!
    @IBOutlet weak var orangeOn: UIImageView!
    @IBOutlet weak var greenOn: UIImageView!
    
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var switchOnOf: UISwitch!
    var ref: DatabaseReference!
    var now = ["쾌적","원활","혼잡","영업종료"]
    //
    var post = [String:AnyObject]()
    var cnt: Int = 3
    //
    var address: String = ""
    
    var databaseHandle:DatabaseHandle?
    
    let userID = Auth.auth().currentUser?.uid
    
    var getcategory: String = ""
    var refHandle: UInt!
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        let thumbImage = UIImage(named: "가게닫음 버튼부분")
        switchOnOf.thumbTintColor = UIColor.init(patternImage: thumbImage!)
        let backImage = UIImage(named: "가게닫음 밑부분")
        switchOnOf.onTintColor = UIColor.init(patternImage: backImage!)
    
        self.greenOn.isHidden = true
        self.orangeOn.isHidden = true
        self.redOn.isHidden = true
        
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        let get = UserDefaults.standard
        getcategory = get.string(forKey: "mycategory") ?? "none"
        if address != ""{
            addressText.text = address
        }else{
            addressText.text = "등록을 해주세요 ->"
        }
    }
    @objc func OnOff(){
        
    }
    
    @IBOutlet weak var NowTraffic: UITextField!
    
    @IBAction func Green(_ sender: Any) {
        //For Send
        if getcategory != "none"{
        self.ref.child("Users").child(getcategory).child(userID!).child("now").setValue(now[0])
        
        self.NowTraffic.text = "Green"
            self.greenOn.isHidden = false
            self.orangeOn.isHidden = true
            self.redOn.isHidden = true
        }else{
            print("error category")
        }
    }
    
    
    @IBAction func Orange(_ sender: Any) {
        //For Send
        if getcategory != "none"{
        self.ref.child("Users").child(getcategory).child(userID!).child("now").setValue(now[1])
        
        self.NowTraffic.text = "Orange"
            self.greenOn.isHidden = true
            self.orangeOn.isHidden = false
            self.redOn.isHidden = true
        }else{
            print("error category")
        }
    }
    
    @IBAction func Red(_ sender: Any) {
        //For Send
        if getcategory != "none"{
        self.ref.child("Users").child(getcategory).child(userID!).child("now").setValue(now[2])
        
        self.NowTraffic.text = "Red"
            self.greenOn.isHidden = true
            self.orangeOn.isHidden = true
            self.redOn.isHidden = false
        }else{
            print("error category")
        }
    }
    
    @IBAction func unwindToVCInitial(segue: UIStoryboardSegue) {
    
    }
}
