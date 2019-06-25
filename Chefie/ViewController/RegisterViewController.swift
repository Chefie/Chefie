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
import CodableFirebase

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
    }
    
    func register() {
        
        //  self.performSegue(withIdentifier: "registerScreen", sender: self)
    }
    
    func launchMainScreen(info : AutoLoginInfo) {
        
        let delegate =  UIApplication.shared.delegate as! AppDelegate
        delegate.doAutoLogin(info: info)
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
                    
                    //                    self.registerUser(email: self.textFieldEmail.text!, password: self.textFieldPassword.text!)
                    
                    let db = Firestore.firestore()
                    
                    //Comprobando que no hay ya un usuario con el mismo UID para no volver a insertar.
                    //Si no hay se inserta el user en la BBDD.(Tabla Users FireStore)
                    db.collection("Users").whereField("id", isEqualTo: Auth.auth().currentUser!.uid)
                        .getDocuments() { (querySnapshot, err) in
                            
                            let co = querySnapshot?.count
                            
                            if  querySnapshot?.count == 0 {
                                
                                let fullName = Auth.auth().currentUser!.email
                                let fullNameArr = fullName!.components(separatedBy: "@")
                                let firstName = fullNameArr[0] //First
                                //let lastName = fullNameArr[1] //Last
                                
                                let usuarioChefie = ChefieUser()
                                usuarioChefie.id = Auth.auth().currentUser!.uid
                                usuarioChefie.userName = firstName
                                usuarioChefie.email = Auth.auth().currentUser!.email
                                usuarioChefie.fullName = ""
                                usuarioChefie.biography = ""
                                usuarioChefie.isPremium = false
                                usuarioChefie.deleted = false
                                usuarioChefie.followers = 0
                                usuarioChefie.following = 0
                                usuarioChefie.profilePic = ""
                                usuarioChefie.profileBackgroundPic = ""
                                usuarioChefie.gender = "Male"
                                usuarioChefie.community = ""
                                usuarioChefie.location = ""
                                
                                self.insertUser(user: usuarioChefie, completion: {
                                    
                                    if Auth.auth().currentUser != nil{
                                        
                                        self.launchMainScreen(info : AutoLoginInfo(email: mail, pass: pass))
                                    }
                                })                         
                            }
                            else {
                                
                                if Auth.auth().currentUser != nil{
                                    
                                    self.launchMainScreen(info : AutoLoginInfo(email: mail, pass: pass))
                                }
                            }
                    
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
     
                            }
                    }
                    
                    self.textFieldEmail.text = ""
                    self.textFieldPassword.text = ""
                    self.textFieldPassword2.text = ""
              
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
    
    //    func registerUser(email: String, password: String){
    //        self.db.collection("Users").document().setData([
    //            "email":self.textFieldEmail.text!,
    //            "password":self.textFieldPassword.text!
    //        ]) { err in
    //            if let err = err {
    //                print("Error writing document: \(err)")
    //            } else {
    //                print("Document successfully written!")
    //            }
    //        }
    //    }
    
    
    //Metodo que hace el insert de un Usuario en la BBDD.
    func insertUser(user: ChefieUser, completion: @escaping () -> Void) {
        let usersRef = Firestore.firestore().collection("Users")
        
        do {
            
            let model = try FirestoreEncoder().encode(user)
            usersRef.addDocument(data: model) { (err) in
                if err != nil {
                    print("---> Algo ha ido mal.")
                } else {
                    print("---> Usuario insertado con exito.")
                    //print("Model: \(model)")

                    completion()
                }
            }
        } catch  {
            print("Invalid Selection.")
        }
    }
}

