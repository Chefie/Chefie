//
//  Route.swift
//  Chefie
//
//  Created by Nicolae Luchian on 14/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation

class Route : Codable {
    
    //Lista de sitios
    //Nombre - ArrayImagen - Ubicacion - Fecha
    
    var id : String?
    var idUser : String?
    var title : String?
    var description : String?
    var multimedia : Array<Media>?
    var likes: Array<Like>?
    var comments : Array<Comment>?
    var community : Community?
    var placeList: Array<Place>?
    
    
    required init() {
        
    }
}
