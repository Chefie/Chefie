
import UIKit
import Firebase
import GoogleSignIn

let appContainer = AppContainer()
let gLabelRadius = 4
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //AQUI SE COMBRUEBA SI HAY ALGO GUARDADO EN EL USER DEFAULTS
        //EN LA KEY "runed"
        let isLogin = UserDefaults.standard.string(forKey: "runed")
        //    self.NextViewController(storybordid: "loginView")
         //  self.NextViewController(storybordid: "loginView")
        if isLogin == "vamos"{
          self.NextViewController(storybordid: "loginView")
        }else{
            self.NextViewController(storybordid: "sliderView")
        }
        return true
    }
    //METODO QUE RECIBE EL ID DE LA VISTA Y NOS SACA UNA U OTRA VISTA
    //DEPENDIENDO DE LO QUE HAY GUARDADO EN EL USERDEFAULTS
//    func NextViewController(storybordid:String)
//    {
//
//        let storyBoard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
//        let exampleVC = storyBoard.instantiateViewController(withIdentifier:storybordid )
//        // self.present(exampleVC, animated: true)
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window?.rootViewController = exampleVC
//        self.window?.makeKeyAndVisible()
//    }
//
    
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
                    
                    //Perform Segue to main screen
                    let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "mainScreen") as UIViewController
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = initialViewControlleripad
                    self.window?.makeKeyAndVisible()
                    
                }else{
                    print(error?.localizedDescription)
                }
                
            }
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

