//
//  StateProcedure.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation
import Alamofire
import ProcedureKit

final class StateProcedure: Procedure, OutputProcedure {
    var output: Pending<ProcedureResult<[State]>> = .pending
    
    private let requestedCountry : String
    private let network          : NetworkService
    
    init(_ country: String, network: NetworkService) {
        self.requestedCountry = country
        self.network          = network
        
        super.init()
    }
    
    override func execute() {
        getStates { states in
            if let states = states {
                self.output = .ready(.success(states))
            } else {
                self.cancel()
            }
            
            self.finish()
        }
    }
    
    private func getStates(_ compilation: @escaping ([State]?) -> Void) {
        guard let headers = network.getHeaders() else { return }
        let url = "https://www.universal-tutorial.com/api/states/\(requestedCountry)"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).response { [weak self] data in
            guard let self = self else { return }
            guard let data = data.data else {
                compilation(nil)
                return
            }
            
            do {
                let statesModel = try JSONDecoder().decode([StateModelResponse].self, from: data)
                let states      = self.getStatesObjects(statesModel)
                compilation(states)
            } catch {
                compilation(nil)
            }
        }
    }
    
    private func getStatesObjects(_ models: [StateModelResponse]) -> [State] {
        var buffer : [State] = []
        models.forEach {
            let state = StateFactory.createState($0)
            buffer.append(state)
        }
        
        return buffer
    }
}
