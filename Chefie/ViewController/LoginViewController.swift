import Foundation
import UIKit
import Firebase
import GoogleSignIn
import FirebaseFirestore
import CodableFirebase

struct AutoLoginInfo {
    
    var email : String?
    var pass : String?
}

class LoginViewController: UIViewController, UIApplicationDelegate, UITextFieldDelegate, GIDSignInUIDelegate{
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPass: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var labelFeedback: UILabel!
    
    @IBOutlet weak var pinkSquare: UIImageView!
    @IBOutlet weak var logoChefie: SpringImageView!
    
    let alertService = AlertService()
    
    //Button Action para el login con Google
    @IBAction func loginGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    var autoLoginInfo : AutoLoginInfo?
    
    var db: Firestore!
    
    //let refUsers = Database.database().reference().child("Users")
    
    //Creando la referencia de la baseDeDatos
    var ref: DatabaseReference!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        pinkSquare.layer.cornerRadius = pinkSquare.frame.height/25
        pinkSquare.layer.shadowOpacity = 5
        pinkSquare.layer.shadowOffset = CGSize.zero
        pinkSquare.layer.shadowRadius = 10
        
        //Google LogIn Shared Instance
        GIDSignIn.sharedInstance().uiDelegate = self
        
        self.textFieldEmail.delegate = self
        self.textFieldPass.delegate = self
    }
    
    func autoLogin() {
        textFieldEmail.text = autoLoginInfo?.email
        textFieldPass.text = autoLoginInfo?.pass
        
        buttonLoginAction(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        textFieldPass.text = ""
        
        if self.autoLoginInfo != nil {
            
            autoLogin()
        }
        else {
            
            if Auth.auth().currentUser != nil{
                
                let id = Auth.auth().currentUser!.uid
                doAfterLogin(id: id)
            }
        }
    }
    
    func doAfterLogin(id : String) {
        
        appContainer.userRepository.getUserById(id: id) { (result : ChefieResult<ChefieUser>) in
            
            switch result {
                
            case .success(let user) :
                
                appContainer.dataManager.localData.onLogin(user: user)
                self.launchMainScreen()
//                self.dismiss(animated: false) {
//                    
//                }
//                
                break
            case .failure(_) : break
            }
        }
    }
    
    //Antes de que salga la Vista se combrueba si hay un usuario logueado.
    //Si lo hay, se produce un Segue hacia la Viste del Home.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logoChefie.animation = "squeezeDown"
        logoChefie.duration = 1.3
        logoChefie.animate()
    }
    
    func launchMainScreen() {
        
        self.dismiss(animated: true) {
            
        }
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialVC : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "mainScreen") as UIViewController

        self.present(initialVC, animated: true)
    }
    
    //Metodo que hace el Login a traves del email y pass de Firebase.
    //Tambien muestra al usuario todos los errores posibles.
    @IBAction func buttonLoginAction(_ sender: Any) {
        
        let email = textFieldEmail.text
        let pass = textFieldPass.text
        
        //        appContainer.userRepository.login(email: email!, password: pass!) { (result: ChefieResult<ChefieUser>) in
        //
        //            switch result {
        //            case .success(let chefieUser):
        //
        //                let val = chefieUser
        //            case .failure(let error):
        //                // Ups, there is something wrong
        //                print(error)
        //            }
        //        }
        
        if(email != "" && pass != ""){
            Auth.auth().signIn(withEmail: email!, password: pass!) {user, error in
                if error == nil && user != nil{
                    self.dismiss(animated: false, completion: nil)
                    
                    let userID : String = (Auth.auth().currentUser?.uid)!
                    self.doAfterLogin(id: userID)
                }else{
                    print("Error loging in: \(error!.localizedDescription)")
                    self.labelFeedback.text = "Wrong Email or password"
                    self.textFieldEmail.text = ""
                    self.textFieldPass.text = ""
                }
            }
        }else{
            labelFeedback.text = "Please enter your Email and Password"
            self.textFieldEmail.text = ""
            self.textFieldPass.text = ""
        }
    }
    
    //Metodo que hace el RESET PASSWORD a traves de un Alert.
    //Se proporciona un email, si existe en la bbdd se envia
    // un correo con un link para poder resetear el password.
    @IBAction func forgotPass(_ sender: Any) {
        let alertVC = alertService.alert(title: "Forgot password?", body: "Enter your email address", buttonTitle: "Reset Password")
        
        present(alertVC,animated: true,completion: nil)
        //PRESENT ALERT
        //self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    //Ocultar el keybord haciendo click en la pantalla.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Metodo que hace el insert de un Usuario en la BBDD.
    func insertUser(user: ChefieUser) {
        //        let usersRef = Firestore.firestore().collection("Users")
        //
        //        do {
        //
        //            let model = try FirestoreEncoder().encode(user)
        //            usersRef.addDocument(data: model) { (err) in
        //                if err != nil {
        //                    print("---> Algo ha ido mal.")
        //                } else {
        //                    print("---> Usuario insertado con exito.")
        //                    //print("Model: \(model)")
        //                }
        //            }
        //
        //        } catch  {
        //            print("Invalid Selection.")
        //        }
        //
        
    }
}
