//
//  AlertDeleteController.swift
//  Chefie
//
//  Created by Nicolae Luchian on 01/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit


class AlertDeleteController: UIViewController {

     let alertService = AlertServiceDelete()
    
    @IBOutlet weak var vistaAlerta: UIView!
    @IBOutlet weak var alertAction: CustomButtons!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertBody: UILabel!
    
    
    @IBOutlet weak var contenedorTitulo: UIImageView!
    var titleLabel = String()
    var messageLabel = String()
    
    var actionButtonTitle = String()
    //Setea los atributos dentro de la AlertView
    func setupAlertViews(){
        alertTitle.text = titleLabel
        alertBody.text = messageLabel
        alertAction.setTitle(actionButtonTitle, for: .normal)
        
    }
    
    
    @IBAction func didTapCancel(_ sender: Any) {
         dismiss(animated: true)
    }
    
    @IBAction func didTapAction(_ sender: Any) {
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)

            contenedorTitulo.layer.cornerRadius = contenedorTitulo.frame.height/10
            vistaAlerta.layer.cornerRadius = vistaAlerta.frame.height/50
            vistaAlerta.layer.shadowOpacity = 5
            vistaAlerta.layer.shadowOffset = CGSize.zero
            vistaAlerta.layer.shadowRadius = 15
            setupAlertViews()
            
        }
}
