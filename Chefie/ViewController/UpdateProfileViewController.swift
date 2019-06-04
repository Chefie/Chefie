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


class UpdateProfileViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    let db = Firestore.firestore()
    
    //Array comunidades de España
    let comunidades = ["Andalucía", "Aragón", "Canarias", "Cantabria", "Castilla y León", "Castilla-La Mancha", "Cataluña", "Ceuta", "Comunidad Valenciana", "Comunidad de Madrid", "Extremadura", "Galicia", "Islas Baleares", "La Rioja", "Melilla", "Navarra", "País Vasco", "Principado de Asturias", "Región de Murcia"]
    
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
    @IBAction func genreAction(_ sender: DLRadioButton) {
        
        if(sender.tag == 1){
            genre = "Female"
        }else{
            genre = "Male"
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
    
    //Metodo que hace un apdate del usuario logueado.
    func modificarUsuario(){
        
        var id =  Auth.auth().currentUser!.uid
        self.db.collection("Users")
            .whereField("id", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    // Some error occured
                } else if querySnapshot!.documents.count != 1 {
                    // Perhaps this is an error for you?
                } else {
                    let document = querySnapshot!.documents.first
                    document!.reference.updateData([
                        "fullName": self.textFieldFullname.text,
                        "userName": self.textFieldUsername.text,
                        "biography": self.textViewBiography.text,
                        "gender" : self.genre,
                        "community": self.comunidadUser,
                        "location" : self.provinciaUser
                        ])
                    
                    
                    let alert = UIAlertController(title: "Profile updated succesfully", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            
                            let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let exampleVC = storyBoard.instantiateViewController(withIdentifier: "mainScreen" )
                            
                            self.present(exampleVC, animated: true)
                            
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                            
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
        }
        
        //timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(goToMainAfterUpdate), userInfo: nil, repeats: true)

    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
         pickerView.reloadComponent(0)
         pickerView.reloadComponent(1)
        
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
        
        //Nav-Bar Settings
        self.navigationItem.title = "Settings"
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Zapfino", size: 13)!]
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(showDeleteAlert))
        navigationItem.rightBarButtonItem = button
        
        navigationItem.leftBarButtonItem?.title = "<"
        //        navigationItem.leftItemsSupplementBackButton = true
        //    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(close))
        //
        
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
            comunidadUser = comunidades[selected]
            return comunidades[row]
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
        
       /////////////////////////////////////////Dar nombre personalizado a la tabla de la bbdd Users.
//        Firestore.firestore().collection("Users").document("averQueloQue").setData(["item": "test"])
        
//        let db = Firestore.firestore()
//        db.collection("Users").document(Auth.auth().currentUser!.uid).setData(["Test": "Ok"])
        
        print("----->   Borrando usuario UNDER CONSTRUCTION")
        
        let alertVC = alertService.alert(title: "Delete Account", body: "You're sure you want to delete your Chefie account?", buttonTitle: "Yes, I'm sure!")
        
        present(alertVC,animated: true,completion: nil)
       
        
    }
    //Metodo que borra un usuario de la bbdd. Cambia atributo 'deleted'
   
    
    @IBAction func logOut(_ sender: Any) {
        
        
        // LOG OUT
        try! Auth.auth().signOut()
        try! GIDSignIn.sharedInstance()?.signOut()
        
        
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
        self.present(controller, animated: true, completion: nil)
        
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    //Ocultar el keybord haciendo click en la pantalla.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        
    }
    
    //Va comprobando si el usuario ha llenado los campos y muestra boton.
    @objc func checkIfDone(){
        
        if(textFieldFullname.text != "" && textFieldUsername.text != "" && textViewBiography.text != ""){
            btnDone.isHidden = false
        }else{
            btnDone.isHidden = true
        }
    }
    
    //Va al Home despues de hacer el update.
    @objc func goToMainAfterUpdate(){
        
        //timerUpdate.invalidate()
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let exampleVC = storyBoard.instantiateViewController(withIdentifier: "mainScreen" )
        
        self.present(exampleVC, animated: true)
        
        
    }
}
