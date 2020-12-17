//
//  SignUpViewController.swift
//  Traffic
//
//  Created by 김민국 on 2017. 6. 25..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet var Email: UITextField!
    @IBOutlet var Password: UITextField!
    @IBOutlet var Name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
    @IBAction func signUpBtn_Touch(_ sender: Any) {
        let _ID = Email.text
        let _name = Name.text
        let _Pw: String
        
        _Pw = Password.text!
        view.endEditing(true)
        Auth.auth().createUser(withEmail: _ID!, password: _Pw, completion: { (user: User?, error: Error?) in
            if error != nil{
                print(error!.localizedDescription)
            }else
            {
                print("done")
            }
            let ref = Database.database().reference()
            let usersReference = ref.child("users")
            //print(usersReference.description())
            let uid = user?.uid
            let newUserReference = usersReference.child(uid!)
            newUserReference.setValue(["username": _name, "email": _ID])
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
