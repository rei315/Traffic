//
//  ViewController.swift
//  Traffic
//
//  Created by 김민국 on 2017. 6. 25..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuth
import Firebase
import FirebaseDatabase


class SignInViewController: UIViewController {

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!

    @IBOutlet weak var Select: UISegmentedControl!

    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func SignIn(_ sender: Any) {
        ref = Database.database().reference()
        let email = Email.text
        let pass = Password.text
        view.endEditing(true)
        Auth.auth().signIn(withEmail: email!, password: pass!, completion: { (user: User?, error: Error?) in
            if error != nil{
                print(error!.localizedDescription)
                print("오류")
            }else{

                print("잘햇어")
                
                if self.Select.selectedSegmentIndex == 0{
                    let um = UIStoryboard(name: "UserMap", bundle: nil).instantiateViewController(withIdentifier: "UserMap")
                    self.present(um, animated: true, completion: nil)

                }else{
                    let vc = UIStoryboard(name: "Manager", bundle: nil).instantiateViewController(withIdentifier: "Main")
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
        })
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

