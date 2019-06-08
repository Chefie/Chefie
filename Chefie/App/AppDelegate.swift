import UIKit
import Firebase
import GoogleSignIn
import AWSS3
import AWSCore
import AWSMobileClient
import CodableFirebase

let appContainer = AppContainer()
let gLabelRadius = 4
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession identifier: String,
                     completionHandler: @escaping () -> Void) {
        
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            guard error == nil else {
                print("Error initializing AWSMobileClient. Error: \(error!.localizedDescription)")
                return
            }
            print("AWSMobileClient initialized.")
        }
        
        setup()
        
        //provide the completionHandler to the TransferUtility to support background transfers.
        AWSS3TransferUtility.interceptApplication(application,
                                                  handleEventsForBackgroundURLSession: identifier,
                                                  completionHandler: completionHandler)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.application(application, handleEventsForBackgroundURLSession: AppSettings.TransferUtilityIdentifier) {
            
        }
        
        return true
    }
    
    func setup() {
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        configureS3()
        
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //AQUI SE COMBRUEBA SI HAY ALGO GUARDADO EN EL USER DEFAULTS
        //EN LA KEY "runed"
        let isLogin = UserDefaults.standard.string(forKey: "runed")
        //self.NextViewController(storybordid: "loginView")
        //self.NextViewController(storybordid: "loginView")
        if isLogin == "vamos"{
            self.NextViewController(storybordid: "loginView")
        }else{
            self.onShowCase()
        }
    }
    
    func configureS3() {
        
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            guard error == nil else {
                print("Error initializing AWSMobileClient. Error: \(error!.localizedDescription)")
                return
            }
            print("AWSMobileClient initialized.")
        }
        
        //Setup credentials, see your awsconfiguration.json for the "YOUR-IDENTITY-POOL-ID"
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.USEast1, identityPoolId: "")
        
        //Setup the service configuration
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialProvider)
        
        //Setup the transfer utility configuration
        let tuConf = AWSS3TransferUtilityConfiguration()
        tuConf.isAccelerateModeEnabled = true
        tuConf.bucket = "chefiebucket"
        //tuConf.multiPartConcurrencyLimit = 5
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        //  Register a transfer utility object asynchronously
        //        AWSS3TransferUtility.register(
        //            with: configuration!,
        //            transferUtilityConfiguration: tuConf,
        //            forKey: AppSettings.TransferUtilityIdentifier
        //        ) { (error) in
        //            if error != nil {
        //                print("Error when registering TransferUtility")
        //            }
        //
        //            print("Loaded")
        //        }
    }
    //METODO QUE RECIBE EL ID DE LA VISTA Y NOS SACA UNA U OTRA VISTA
    //DEPENDIENDO DE LO QUE HAY GUARDADO EN EL USERDEFAULTS
    
    func onShowCase()
    {
        let storyBoard:UIStoryboard = UIStoryboard(name: "Showcase", bundle: nil)
        let exampleVC = storyBoard.instantiateViewController(withIdentifier: "sliderView" )
        // self.present(exampleVC, animated: true)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = exampleVC
        self.window?.makeKeyAndVisible()
    }
    
    func NextViewController(storybordid:String)
    {
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let exampleVC = storyBoard.instantiateViewController(withIdentifier:storybordid )
        // self.present(exampleVC, animated: true)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = exampleVC
        self.window?.makeKeyAndVisible()
    }
    
    //Google SignIn
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            print(error.localizedDescription)
            return
        }else{
            guard let authentication = user.authentication else{return}
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signInAndRetrieveData(with: credential) {(result,error) in
                if(error == nil){
                    print(result?.user.email)
                    print(result?.user.displayName)
                    
                    let userID : String = (Auth.auth().currentUser?.uid)!
                    
                    appContainer.userRepository.getUserById(id: userID) { (result : ChefieResult<ChefieUser>) in
                        
                        switch result {
                            
                        case .success(let user) :
                            
                            appContainer.dataManager.localData.onLogin(user: user)
                            
                            //Perform Segue to main screen
                            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "mainScreen") as UIViewController
                            
                            let navigationController = UINavigationController(rootViewController: initialViewControlleripad)
                            
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            self.window?.rootViewController = navigationController
                            self.window?.makeKeyAndVisible()
                            break
                        case .failure(_) : break
                        }
                    }
                    
                    //   appContainer.dataManager.localData.onLogin(id: userID)
                    
                    let db = Firestore.firestore()
                    
                    //Comprobando que no hay ya un usuario con el mismo UID para no volver a insertar.
                    //Si no hay se inserta el user en la BBDD.(Tabla Users FireStore)
                    db.collection("Users").whereField("id", isEqualTo: Auth.auth().currentUser!.uid)
                        .getDocuments() { (querySnapshot, err) in
                            
                            if  querySnapshot?.count == 0 {
                                
                                let usuarioChefie = ChefieUser()
                                usuarioChefie.id = Auth.auth().currentUser!.uid
                                usuarioChefie.userName = ""
                                usuarioChefie.email = Auth.auth().currentUser!.email
                                usuarioChefie.fullName = ""
                                usuarioChefie.biography = ""
                                usuarioChefie.isPremium = false
                                usuarioChefie.deleted = false
                                usuarioChefie.followers = 0
                                usuarioChefie.following = 0
                                usuarioChefie.profilePic = ""
                                usuarioChefie.profileBackgroundPic = ""
                                usuarioChefie.gender = ""
                                usuarioChefie.community = ""
                                usuarioChefie.location = ""
                                
                                self.insertUser(user: usuarioChefie)
                            }
                            
                            
                            if let err = err {
                                print("Error getting documents: \(err)")
                                
                                
                                
                            } else {
                                //                                    for document in querySnapshot!.documents {
                                //                                        print("\(document.documentID) => \(document.data())")
                                //                                    }
                                
                                
                                
                            }
                    }
                    
                }else{
                    print(error?.localizedDescription)
                }
                
            }
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
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

