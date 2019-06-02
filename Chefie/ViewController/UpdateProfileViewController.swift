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
//        let userID = Auth.auth().currentUser!.uid
        
        timer.invalidate()
        //Creando el usuario y sus atributos.
        let user = ChefieUser()
        
        let idUser = Auth.auth().currentUser!.uid
        let username = textFieldUsername.text
        let email = Auth.auth().currentUser!.email
        let fullName = textFieldFullname.text
        let bio = textViewBiography.text
        
        user.id = idUser
        user.userName = username
        user.email = email
        user.fullName = fullName
        user.biography = bio
        user.isPremium = false
        user.deleted = false
        user.followers = 0
        user.following = 0
        user.gender = genre
        user.community = comunidadUser
        user.location = provinciaUser
        
    
        if(textFieldFullname.text != "" && textFieldUsername.text != ""){
             insertUser(user: user)
        }
       
       
    }
    
    //Metodo que hace el insert de un Usuario en la BBDD.
    func insertUser(user: ChefieUser) {
        let usersRef = Firestore.firestore().collection("Users")
        
        do {
            
            let model = try FirestoreEncoder().encode(user)
            usersRef.addDocument(data: model) { (err) in
                if err != nil {
                    print("---> Algo ha ido mal.")
                } else {
                    print("---> Usuario insertado con exito.")
                    //print("Model: \(model)")
                }
            }
            
        } catch  {
            print("Invalid Selection.")
        }
        
        
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(borrarUsuario))
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
             comunidadUser = comunidades[row]
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
    @objc func borrarUsuario(){
        print("----->   Borrando usuario UNDER CONSTRUCTION")
        
        
        let alertVC = alertService.alert(title: "Delete Account", body: "You're sure you want to delete your Chefie account?", buttonTitle: "Yes, I'm sure!")
        
        present(alertVC,animated: true,completion: nil)
       
    }
    
    //Ocultar el keybord haciendo click en la pantalla.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
      
    }
    
    @objc func checkIfDone(){
        
        if(textFieldFullname.text != "" && textFieldUsername.text != "" && textViewBiography.text != ""){
            btnDone.isHidden = false
        }else{
            btnDone.isHidden = true
        }
    }
}
