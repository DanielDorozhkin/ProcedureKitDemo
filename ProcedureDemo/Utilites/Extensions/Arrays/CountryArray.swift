//
//  CountryArray.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 03/01/2022.
//

import Foundation

extension Array where Element == CountryModelResponse {
    func parseToObjects() -> [Country] {
        return self.map { CountryFactory.createCountry($0) }
    }
}
