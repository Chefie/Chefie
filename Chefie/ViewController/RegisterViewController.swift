//
//  ViewController.swift
//  Chefie_Register_Test
//  Users/nicolaeluchian/Documents/Chefie/Chefie
//  Created by Nicolae Luchian on 22/01/2019.
//  Copyright © 2019 Nicolae Luchian. All rights reserved.
//

import UIKit
//importing Firebase
import Firebase
import GoogleSignIn
import FirebaseFirestore

class RegisterViewController : UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var textFieldEmail: UITextField! //email
    @IBOutlet weak var textFieldPassword: UITextField! //password1
    @IBOutlet weak var textFieldPassword2: UITextField! //password2
    @IBOutlet weak var labelMessage: UILabel! //feedback message
    @IBOutlet weak var buttonRegister: UIButton!
    
    @IBOutlet weak var pinkSquare: UIImageView!
    
    @IBOutlet weak var logoChefie: SpringImageView!
    
    
    let db = Firestore.firestore()
    
    var test = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        pinkSquare.layer.cornerRadius = pinkSquare.frame.height/25
        pinkSquare.layer.shadowOpacity = 5
        pinkSquare.layer.shadowOffset = CGSize.zero
        pinkSquare.layer.shadowRadius = 10
        //FirebaseApp.configure()
        self.textFieldEmail.delegate = self
        self.textFieldPassword.delegate = self
        self.textFieldPassword2.delegate = self
    }
    //Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil{
            self.performSegue(withIdentifier: "toHomeScreen", sender: self)
        }
    }
    
    @IBAction func buttonRegister(_ sender: Any) {
        let mail = textFieldEmail.text
        let pass = textFieldPassword.text
        let repeatPass = textFieldPassword2.text
        
        if(pass == repeatPass){
            buttonRegister.isEnabled = true
            Auth.auth().createUser(withEmail: mail!, password: pass!) { (user, error) in
                if error == nil && user != nil{
                    self.labelMessage.text = "You are succesfully registered"
                    
                    self.registerUser(email: self.textFieldEmail.text!, password: self.textFieldPassword.text!)
                    
                    self.textFieldEmail.text = ""
                    self.textFieldPassword.text = ""
                    self.textFieldPassword2.text = ""
                    if Auth.auth().currentUser != nil{
                        self.performSegue(withIdentifier: "toHomeScreen", sender: self)
                    }
                }else{
                    self.labelMessage.text = "\(error!.localizedDescription)"
                    print("error creating user: \(error!.localizedDescription)")
                }
            }
        }else{
            buttonRegister.isEnabled = false
            labelMessage.text = "Passwords don't match."
            textFieldPassword.text = ""
            textFieldPassword2.text = ""
        }
    }
    
    func registerUser(email: String, password: String){
        self.db.collection("Users").document().setData([
            "email":self.textFieldEmail.text!,
            "password":self.textFieldPassword.text!
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}

