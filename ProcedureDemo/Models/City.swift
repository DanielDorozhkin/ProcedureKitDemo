//
//  City.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation

class City {
    let name: String
    
    init(_ name: String) {
        self.name = name
    }
}

struct CityModelResponse: Decodable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "city_name"
    }
}
