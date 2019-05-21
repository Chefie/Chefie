import Foundation
import UIKit
import Firebase
import GoogleSignIn
import FirebaseFirestore

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
    
    var db: Firestore!
    
    //let refUsers = Database.database().reference().child("Users")
    
    //Creando la referencia de la baseDeDatos
    var ref: DatabaseReference!
    
    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Configuracion de instancia compartida
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        print(db)
        return true
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        textFieldPass.text = ""
        
        
    }
    
    //Antes de que salga la Vista se combrueba si hay un usuario logueado.
    //Si lo hay, se produce un Segue hacia la Viste del Home.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logoChefie.animation = "squeezeDown"
        logoChefie.duration = 1.3
        logoChefie.animate()
        
        if Auth.auth().currentUser != nil{
          //  self.performSegue(withIdentifier: "mainScreen", sender: self)
        }
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
                    if Auth.auth().currentUser != nil{
                        
                        
                        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let exampleVC = storyBoard.instantiateViewController(withIdentifier: "mainScreen" )
                        
                        self.present(exampleVC, animated: true)
                      
                    //    self.performSegue(withIdentifier: "mainScreen", sender: self)
                    }

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
    
    
    
    
    
    
    
    
}
