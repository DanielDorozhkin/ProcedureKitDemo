//
//  StateFactory.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation

class StateFactory {
    static func createState(_ model: StateModelResponse) -> State {
        let state = State(model.name)
        return state
    }
}
