//
//  CitiesProcedureGroup.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation
import ProcedureKit

class CitiesProcedureGroup: GroupProcedure, OutputProcedure {
    var output: Pending<ProcedureResult<[State]>> = .pending
    
    init(_ country: Country) {
        let stateProcedure = StateProcedure(country.name)
        let citiesProcedure = CityProcedure().injectResult(from: stateProcedure)
        
        super.init(operations: [stateProcedure, citiesProcedure])
        
        bind(from: citiesProcedure)
    }
}
