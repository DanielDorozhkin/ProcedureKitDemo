//
//  State.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation

final class State: Equatable {
    let name : String
    private(set) var cities = [City]()
    
    init(_ name: String) {
        self.name = name
    }
    
    func injectCities(_ cities: [City]) {
        self.cities = cities
    }
    
    static func == (lhs: State, rhs: State) -> Bool {
        return lhs.name == rhs.name
    }
}

struct StateModelResponse: Decodable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "state_name"
    }
}
