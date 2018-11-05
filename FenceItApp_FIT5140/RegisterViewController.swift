//
//  RegisterViewController.swift
//  FenceItApp_FIT5140
//
//  Created by Alfredo Zamudio on 4/11/18.
//  Copyright © 2018 Alfredo Zamudio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var sureField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    var getEmailUser:String = ""
    var databaseRef = DatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        sureField.delegate = self
        addressField.delegate = self
        phoneField.delegate = self
        emailField.delegate = self
        emailField.text = getEmailUser
    }
    
    @IBAction func saveUser(_ sender: Any) {
        let userId = Auth.auth().currentUser!.uid
        databaseRef = Database.database().reference().child("users")
        let refChild = databaseRef.childByAutoId()
        let dic = NSMutableDictionary()
        dic .setValue("1", forKey: "id")
        dic .setValue(nameField.text, forKey: "name")
        dic .setValue(sureField.text, forKey: "lastname")
        dic .setValue(addressField.text, forKey: "address")
        dic .setValue(phoneField.text, forKey: "phone")
        dic .setValue(emailField.text, forKey: "email")
        
        refChild.updateChildValues(dic as [NSObject : AnyObject]) { (error, ref) in
            if(error != nil){
                print("Error",error)
            }else{
                print("\n\n\n\n\nAdded successfully...")
            }
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
