//
//  UpdateProfileViewController.swift
//  Chefie
//
//  Created by Nicolae Luchian on 31/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import UIKit
import DLRadioButton
import Firebase
import GoogleSignIn
import FirebaseFirestore
import CodableFirebase
import FaveButton
import SCLAlertView

class UpdateProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate , UITextViewDelegate, UITextFieldDelegate {
    
    let db = Firestore.firestore()
    
    var usernameGlobal: ChefieUser!
    
    var comunidades = [Community]()
    
    //Arrays de Strings de Provincias
    let andalucía =  ["Almeria","Cadiz","Cordoba","Granada","Huelva","Jaen","Malaga","Sevilla"]
    let aragón = ["Huesca","Teruel","Zaragoza"]
    let canarias = ["Las Palmas","Santa Cruz de Tenerife"]
    let cantabria = ["Cantabria"]
    let castillaYLeon = ["Avila","Burgos","Leon","Palencia","Salamanca","Segovia","Soria","Valladolid","Zamora"]
    let castillaLaMancha = ["Albacete","Ciudad Real","Cuenca","Guadalajara","Toledo"]
    let catalunya = ["Barcelona","Girona","Lleida","Tarragona"]
    let ceuta = ["Ceuta"]
    let comunidadValenciana = ["Alicante","Castellon","Valencia"]
    let comunidadDeMadrid = ["Madrid"]
    let extremadura = ["Badajoz","Caceres"]
    let galicia = ["A Coruña","Lugo","Ourense","Pontevedra"]
    let islasBaleares = ["Baleares"]
    let laRioja = ["La Rioja"]
    let melilla = ["Melilla"]
    let navarra = ["Navarra"]
    let paisVasco = ["Alava","Guipuzcoa","Vizcaya"]
    let principadoDeAsturias = ["Asturias"]
    let regionDeMurcia = ["Murcia"]
    
    let alertService = AlertServiceDelete()
    var secondColumnData = [[String]]()
    var timer = Timer()
    var timerUpdate = Timer()
    
    @IBOutlet weak var textFieldFullname: SpringTextField!
    @IBOutlet weak var textFieldUsername: SpringTextField!
    @IBOutlet weak var textViewBiography: SpringTextView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var btnGenre: DLRadioButton!
    @IBOutlet weak var btnDone: FaveButton!
    
    var genre = ""
    var provinciaUser = ""
    var comunidadUser = ""
    var valorComunidadUsuario = ""
    @IBAction func genreAction(_ sender: DLRadioButton) {
        
        if(sender.tag == 1){
            genre = "Female"
        }else{
            genre = "Male"
        }
    }
    
    @IBAction func onGoToChefieTeamSection(_ sender: Any) {
        
        let url = URL(string: "https://master.d25if42x0mnuvf.amplifyapp.com/#team")!
        UIApplication.shared.open(url, options: [:]) { (result ) in
            
        }
    }
    @IBAction func onGoToPrivacySection(_ sender: Any) {
        
        let url = URL(string: "https://master.d25if42x0mnuvf.amplifyapp.com/#privacy")!
        UIApplication.shared.open(url, options: [:]) { (result ) in
            
        }
    }
    
    @IBAction func insertUserInfo(_ sender: Any) {
        
        timer.invalidate()
        //Creando el usuario y sus atributos.
        //        let user = ChefieUser()
        //
        //        let idUser = Auth.auth().currentUser!.uid
        //
        //
        
        if(textFieldFullname.text != "" && textFieldUsername.text != ""){
            modificarUsuario()
        }
    }
    
    func checkIfUsernameExist(username: String, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void{
        let db = Firestore.firestore()
        
        db.collection("Users").whereField("userName", isEqualTo: username)
            .getDocuments() { (querySnapshot, err) in
                
                if  querySnapshot?.count == 0 {
                    
                    completionHandler(.success(true))
                }
                    
                else {
                    
                    completionHandler(.failure("Not found"))
                }
                
        }
    }
    
    func updateUserData(){
        let id = appContainer.getUser().id!
        self.db.collection("Users")
            .whereField("id", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    // Some error occured
                } else if querySnapshot!.documents.count != 1 {
                    // Perhaps this is an error for you?
                } else {
                    let document = querySnapshot!.documents.first
                    
                    document?.reference.updateData([
                        "fullName": self.textFieldFullname.text ?? "",
                        "userName": self.textFieldUsername.text ?? "",
                        "biography": self.textViewBiography.text ?? "",
                        "community": self.comunidadUser,
                        "location" : self.provinciaUser
                        ], completion: { (err
                            ) in
                            
                            appContainer.userRepository.getUserById(id: id, completionHandler: { (result : ChefieResult<ChefieUser>) in
                                
                                switch result {
                                    
                                case .success(let newUser):
     
                                    appContainer.updateUser(user: newUser)
                                    appContainer.userRepository.updateUserDataGlobally(userMin: newUser.mapToUserMin())
                                    
                                    break
                                    
                                case .failure(_) : break
                                }
                            })
                    })
                    
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    //                    alertView.addButton("First Button", target:self, selector:Selector("firstButton"))
                    alertView.addButton("Great!") {
                        
                         EventContainer.shared.ProfileSubject.on(.next(""))
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertView.showSuccess("Your profile was successfully updated", subTitle: "").setDismissBlock {
                        
                       
                    }
                }
        }
    }
    
    //Metodo que hace un apdate del usuario logueado.
    func modificarUsuario(){
        
        if(usernameGlobal.userName != textFieldUsername.text!){
            
            checkIfUsernameExist(username: textFieldUsername.text!) { (result : ChefieResult<Bool>) in
                
                switch result{
                    
                case .success(_):
                    
                    self.updateUserData()
                    
                    break
                    
                case .failure(_):
                    
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: true
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.showWarning("Ups..", subTitle: "This username already exists.")
                    break
                }
            }
        }else{
            self.updateUserData()
        }
    }
    
    func goBackToLogin(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
        self.present(controller, animated: true, completion: nil)
    }
    
    //Metodo que trae los datos del usuario logueado.
    func loadUserInfo() {
        
        appContainer.userRepository.getUserById(id: Auth.auth().currentUser!.uid) { (result : ChefieResult<ChefieUser>) in
            
            switch result {
                
            case .success(let user) :
                
                self.usernameGlobal = user
                
                self.textFieldFullname.text = user.fullName
                self.textFieldUsername.text = user.userName
                self.textViewBiography.text = user.biography
                self.genre = user.gender!
                self.valorComunidadUsuario = user.community!
                
                let gender = user.gender
                
                if (gender == "Male") {
                    
                    self.btnGenre.otherButtons.forEach({ (btn) in
                        btn.isSelected = true
                    })
                }
                else {
                    self.btnGenre.isSelected = true
                }
                
                let item = self.comunidades.firstIndex { (com) -> Bool in
                    com.id == user.community
                }
                
                self.pickerView.selectRow(item ?? 0, inComponent: 0, animated: true)
                
                let secondIndex = self.secondColumnData[self.pickerView.selectedRow(inComponent: 0)].firstIndex(where: { (str) -> Bool in
                    
                    str == user.location
                })
                
                self.pickerView.reloadComponent(1)
                self.pickerView.selectRow(secondIndex ?? 0, inComponent: 1, animated: true)
                break
            case .failure(_) : break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.reloadComponent(0)
        pickerView.reloadComponent(1)
        
        appContainer.communityRepository.getCommunities { (result : ChefieResult<[Community]>) in
            
            switch result {
                
            case .success(let data) :
                
                self.comunidades.removeAll()
                self.comunidades.append(contentsOf: data)
                self.pickerView.reloadAllComponents()
                
                self.loadUserInfo()
                break
            case .failure(_): break
            }
        }
        
        
        //Checking every second if texfields are not empty.
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkIfDone), userInfo: nil, repeats: true)
        btnDone.isHidden = true
        
        
        //Array de arrays de Strings.
        secondColumnData = [andalucía,aragón,canarias,cantabria,castillaYLeon,castillaLaMancha,
                            catalunya,ceuta,comunidadValenciana,comunidadDeMadrid,extremadura,galicia,
                            islasBaleares,laRioja,melilla,navarra,paisVasco,principadoDeAsturias,regionDeMurcia]
        
        //Delegates.
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.reloadAllComponents()
        pickerView.selectRow(0, inComponent: 0, animated: false)
        
        textFieldFullname.delegate = self
        textFieldUsername.delegate = self
        textViewBiography.delegate = self
        //Nav-Bar Settings
        self.navigationItem.title = "Settings"
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: DefaultFonts.ZapFinoXs]
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(showDeleteAlert))
        navigationItem.rightBarButtonItem = button
        
        self.setDefaultBackButton()
        //Biography border and radius.
        textViewBiography.layer.borderWidth = 0.1;
        textViewBiography.layer.cornerRadius = 5.0;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return comunidades.count
        } else {
            let selected = pickerView.selectedRow(inComponent: 0)
            
            return secondColumnData[selected].count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            let selected = pickerView.selectedRow(inComponent: 0)
            comunidadUser = comunidades[selected].id!
            return comunidades[row].name
        } else {
            let selected = pickerView.selectedRow(inComponent: 0)
            
            return secondColumnData[selected][row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
        } else {
            let selected = pickerView.selectedRow(inComponent: 0)
            
            provinciaUser = secondColumnData[selected][row]
            
        }
    }
    
    //Metodo para borrar el usuario con alerta.
    @objc func showDeleteAlert(){
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        let txt = alertView.addTextField("Confirm your email")
        
        alertView.addButton("Submit") {
            if(txt.text == Auth.auth().currentUser!.email){
                
                self.db.collection("Users")
                    .whereField("id", isEqualTo: Auth.auth().currentUser!.uid)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            // Some error occured
                        } else if querySnapshot!.documents.count != 1 {
                            // Perhaps this is an error for you?
                        } else {
                            let document = querySnapshot!.documents.first
                            
                            document!.reference.delete()
                        }
                        
                }
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("Ok") {
                    
                    //Borra el usuario del Auth de Firebase.
                    Auth.auth().currentUser?.delete(completion: { (error : Error?) in
                        try! Auth.auth().signOut()
                        try! GIDSignIn.sharedInstance()?.signOut()
                        let delegate =  UIApplication.shared.delegate as! AppDelegate
                        delegate.reset()
                    })
                    // LOG OUT
                }
                alertView.showSuccess("Your Account has been deleted", subTitle: "")
                
                
            }else{
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: true
                )
                let alertView = SCLAlertView(appearance: appearance)
                alertView.showWarning("Ups..", subTitle: "Email addresses don't match.")
            }
        }
        
        alertView.showEdit("Are you sure you want to delete your account?", subTitle: " Deleting your account is permanent and will remove all content including comments, avatars and profile settings.")
    }
    
    //Metodo que borra un usuario de la bbdd. Cambia atributo 'deleted'
    
    @IBAction func logOut(_ sender: Any) {
        
        // LOG OUT
        try! Auth.auth().signOut()
        try! GIDSignIn.sharedInstance()?.signOut()
        self.view.window?.rootViewController = nil
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true) {
            
        }
        
        let delegate =  UIApplication.shared.delegate as! AppDelegate
        delegate.reset()
    }
    
    //Ocultar el keybord haciendo click en la pantalla.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Va comprobando si el usuario ha llenado los campos y muestra boton.
    @objc func checkIfDone(){
        
        if(textFieldFullname.text != "" && textFieldUsername.text != ""){
            btnDone.isHidden = false
        }else{
            btnDone.isHidden = true
        }
    }
}
