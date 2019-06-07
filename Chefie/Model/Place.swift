//
//  Place.swift
//  Chefie
//
//  Created by Alex Lin on 02/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation

class Place : Codable {
    required init (){
        
    }
    
    var placeName: String?
    var imgList: Array<Media>?
    var coordinates: Coordinate?
    var creation_date: String?
    
}

struct Coordinate : Codable {
    var latitude: String?
    var longitude: String?
}
