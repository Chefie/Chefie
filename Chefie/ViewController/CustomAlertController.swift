//
//  CustomAlertController.swift
//  Chefie
//
//  Created by Nicolae Luchian on 06/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import UIKit

class CustomAlertController: UIView, UIPickerViewDelegate,UIPickerViewDataSource {
    
    var valorComunidad = ""
    
    let comunidades = ["Andalucía", "Aragón", "Canarias", "Cantabria", "Castilla y León", "Castilla-La Mancha", "Cataluña", "Ceuta", "Comunidad Valenciana", "Comunidad de Madrid", "Extremadura", "Galicia", "Islas Baleares", "La Rioja", "Melilla", "Navarra", "País Vasco", "Principado de Asturias", "Región de Murcia"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return comunidades.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let selected = pickerView.selectedRow(inComponent: 0)
        valorComunidad = comunidades[selected]
        return comunidades[row]
    }

    func setup() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func printComunidad(){
        
        print(valorComunidad)
    }
    
    @IBOutlet var labelCommunity: UILabel!
    @IBOutlet var pickerView: UIPickerView!
}
