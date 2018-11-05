//
//  AuthViewController.swift
//  FenceItApp_FIT5140
//
//  Created by Alfredo Zamudio on 1/11/18.
//  Copyright © 2018 Alfredo Zamudio. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userField.delegate = self
        passwordField.delegate = self
        //Looks for single or multiple taps.
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener(
            {auth, user in
                if user != nil {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonClick(_ sender: Any) {
        guard let password = passwordField.text else {
            displayErrorMessage("Please enter a password")
            return;
        }
        guard let email = userField.text else {
            displayErrorMessage("Please enter an email")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            if error != nil {
                self.displayErrorMessage(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func registerButtonClick(_ sender: Any) {
        guard let password = passwordField.text else {
            displayErrorMessage("Please enter a password")
            return;
        }
        guard let email = userField.text else {
            displayErrorMessage("Please enter an email")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password){
            (user, error) in
            if error != nil {
                self.displayErrorMessage(error!.localizedDescription)
                return
            } else {
                let story = UIStoryboard(name: "Main", bundle: nil)
                let pass = story.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                
                pass.getEmailUser = email
                self.navigationController?.pushViewController(pass, animated: true)
            }
        }
        
    }
    
    func displayErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    func goBack(){
        do{
            try Auth.auth().signOut()
            
        }catch{
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
