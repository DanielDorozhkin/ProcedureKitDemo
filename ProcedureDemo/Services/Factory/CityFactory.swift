//
//  CityFactory.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation

final class CityFactory {
    static func createCity(_ model: CityModelResponse) -> City {
        let city = City(model.name)
        return city
    }
}
