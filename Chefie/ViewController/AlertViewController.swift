//
//  AlertViewController.swift
//  Chefie
//
//  Created by Nicolae Luchian on 29/03/2019.
//  Copyright © 2019 Nicolae Luchian. All rights reserved.
//

import UIKit
import Firebase

class AlertViewController: UIViewController {
    
    let alertService = AlertService()
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var vistaAlerta: UIView!
    
    @IBOutlet weak var alertAction: CustomButtons!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertBody: UILabel!
    
    @IBOutlet weak var contenedorTitle: UIImageView!
    var titleLabel = String()
    var messageLabel = String()
    
    var actionButtonTitle = String()
    
    //Setea los atributos dentro de la AlertView
    func setupAlertView(){
        alertTitle.text = titleLabel
        alertBody.text = messageLabel
        alertAction.setTitle(actionButtonTitle, for: .normal)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contenedorTitle.layer.cornerRadius = contenedorTitle.frame.height/10
        vistaAlerta.layer.cornerRadius = vistaAlerta.frame.height/50
        vistaAlerta.layer.shadowOpacity = 5
        vistaAlerta.layer.shadowOffset = CGSize.zero
        vistaAlerta.layer.shadowRadius = 15
        setupAlertView()
        
    }
    
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
        
    }
    
    @IBAction func didTapAction(_ sender: Any) {
        
        //        let alertVC = alertService.alert(title: "Forgot password?", body: "Enter your email address", buttonTitle: "Reset Password")
        
        var resetEmail = String()
        resetEmail = inputTextField.text ?? ""
        Auth.auth().sendPasswordReset(withEmail: resetEmail, completion: { (error) in
            if error != nil{
                let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(resetFailedAlert, animated: true, completion: nil)
            }else {
                let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(resetEmailSentAlert, animated: true, completion: nil)
                
            }
        })
        //dismiss(animated: true)
        
    }
    
    
}
