//
//  CountryFactory.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation

class CountryFactory {
    static func createCountry(_ model: CountryModelResponse) -> Country {
        let country = Country(name: model.name, code: model.code)
        return country
    }
}
