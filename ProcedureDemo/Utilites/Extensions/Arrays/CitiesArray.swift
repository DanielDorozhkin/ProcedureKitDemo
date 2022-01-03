//
//  CitiesArray.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 03/01/2022.
//

import Foundation

extension Array where Element == CityModelResponse {
    func parseToObjects() -> [City] {
        return self.map { CityFactory.createCity($0) }
    }
}
