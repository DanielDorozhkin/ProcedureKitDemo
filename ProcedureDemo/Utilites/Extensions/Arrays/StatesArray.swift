//
//  StatesArray.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 03/01/2022.
//

import Foundation

extension Array where Element == StateModelResponse {
    func parseToObjects() -> [State] {
        return self.map { StateFactory.createState($0) }
    }
}
