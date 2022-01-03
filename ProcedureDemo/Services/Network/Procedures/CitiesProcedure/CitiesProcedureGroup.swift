//
//  CitiesProcedureGroup.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation
import ProcedureKit

final class CitiesProcedureGroup: GroupProcedure, OutputProcedure {
    var output: Pending<ProcedureResult<[State]>> = .pending
    
    init(_ country: Country, network: NetworkService) {
        let stateProcedure  = StateProcedure(country.name, network: network)
        let citiesProcedure = CityProcedure(network).injectResult(from: stateProcedure)
        
        super.init(operations: [stateProcedure, citiesProcedure])
        
        bind(from: citiesProcedure)
    }
}
