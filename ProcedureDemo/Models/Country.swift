//
//  Country.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation

final class Country {
    let name: String
    let code: String
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
}

struct CountryModelResponse: Decodable {
    let name: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case name = "country_name"
        case code = "country_short_name"
    }
}
