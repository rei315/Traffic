//
//  EditRestaurant.swift
//  Traffic
//
//  Created by 김민국 on 2017. 7. 1..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import CoreData

class EditRestaurant: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate {



    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var People: UITextField!
    @IBOutlet weak var Phone: UITextField!
    @IBOutlet weak var Address: UITextField!
    @IBOutlet weak var test: UIImageView!
    @IBOutlet weak var Category: UITextField!

    var data = ["음식점","카페"]
    var picker = UIPickerView()
    
    var getlat:CLLocationDegrees = 0.0
    var getlon:CLLocationDegrees = 0.0
    
    var Intpeople:Int = 0
    var Intphone:UInt = 0
    
    var STrPeople: String = ""
    var STrPhone: String = ""
    
    var ref: DatabaseReference!
    var myrestaurant : [String:Any] = [:]
    
    @IBAction func tabImage(_ sender: Any) {
        print("good")
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true, completion: nil)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Category.text = data[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let select = info[UIImagePickerControllerOriginalImage] as! UIImage
        test.image = select
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "기본 바탕")!
        
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(image, for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        }
        
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: Name.frame.height))
        Name.leftView = paddingView1
        Name.leftViewMode = UITextFieldViewMode.always
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: People.frame.height))
        People.leftView = paddingView2
        People.leftViewMode = UITextFieldViewMode.always
        let paddingView3 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: Phone.frame.height))
        Phone.leftView = paddingView3
        Phone.leftViewMode = UITextFieldViewMode.always
        let paddingView4 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: Address.frame.height))
        Address.leftView = paddingView4
        Address.leftViewMode = UITextFieldViewMode.always
        let paddingView5 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: Category.frame.height))
        Category.leftView = paddingView5
        Category.leftViewMode = UITextFieldViewMode.always
        
        let button = UIButton.init(type: .custom)
        button.addTarget(self, action: #selector(callMethod), for: .touchUpInside)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        imageView.image = UIImage(named: "back")
        //        let label = UILabel(frame: CGRect(x: 35, y: 0, width: 50, height: 30))
        //        label.text = "1234"
        let buttonView = UIView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.height)!/2, width: 90, height: 50))
        button.frame = buttonView.frame
        buttonView.addSubview(button)
        buttonView.addSubview(imageView)
        //        buttonView.addSubview(label)
        let barButton = UIBarButtonItem.init(customView: buttonView)
        self.navigationItem.leftBarButtonItem = barButton
        
        ref = Database.database().reference()
        
        picker.delegate = self
        picker.dataSource = self
        Category.inputView = picker
    }
    @objc func callMethod (){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func SaveInform(_ sender: Any) {
        STrPeople = People.text!
        Intpeople = Int(STrPeople)!
        STrPhone = Phone.text!
        Intphone = UInt(STrPhone)!
        
        myrestaurant["mylatitude"] = getlat
        myrestaurant["mylongitude"] = getlon
        myrestaurant["myname"] = Name.text
        myrestaurant["myphone"] = Intphone
        myrestaurant["mypeople"] = Intpeople
        myrestaurant["myaddress"] = Address.text
        myrestaurant["mycategory"] = Category.text
        myrestaurant["myaccount"] = Auth.auth().currentUser?.uid
        
        let save = UserDefaults.standard
        save.set(Category.text, forKey: "mycategory")
        
        let userID = Auth.auth().currentUser?.uid
        
        self.ref.child("Users").child(Category.text!).child(userID!).setValue(myrestaurant)
        
        let storageref = Storage.storage().reference().child("logo")
        
        if let uploadData = UIImagePNGRepresentation(test.image!){
            storageref.putData(uploadData).observe(.success) { (snapshot) in
                
                let downloadURL = snapshot.metadata?.downloadURL()?.absoluteString
                // Write the download URL to the Realtime Database
                self.ref.child("Users").child(self.Category.text!).child(userID!).child("logoURL").setValue(downloadURL)
            }
        }
        
        performSegue(withIdentifier: "GoInitialView", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoInitialView"){
            let vc = segue.destination as! Traffic
            vc.address = "\(Address.text!) \(Name.text!)"
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
