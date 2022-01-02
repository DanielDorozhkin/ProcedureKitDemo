//
//  CitiesProcedure.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation
import Alamofire
import ProcedureKit

class CityProcedure: Procedure, InputProcedure, OutputProcedure {
    var input  : Pending<[State]>                  = .pending
    var output : Pending<ProcedureResult<[State]>> = .pending
    private let network                            = NetworkService.shared
    
    override func execute() {
        getAllCities { states in
            self.output = .ready(.success(states))
            self.finish()
        }
    }
    
    private func getAllCities(_ compilation: @escaping ([State]) -> Void) {
        guard let states = input.value else { return }
        var buffer = [State]()
        
        states.forEach {
            getCitiesOfState($0) { state in
                buffer.append(state)
                
                if state == states.last {
                    compilation(buffer)
                }
            }
        }
    }
    
    private func getCitiesOfState(_ state: State, _ compilation: @escaping (State) -> Void) {
        guard let headers = network.getHeaders() else { return }
        let url = "https://www.universal-tutorial.com/api/cities/\(state.name)"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).response { [weak self] data in
            guard let self = self else { return }
            guard let data = data.data else {
                compilation(state)
                return
            }
            
            do {
                let cityModels = try JSONDecoder().decode([CityModelResponse].self, from: data)
                let cities     = self.getCityObjects(cityModels)
                
                state.injectCities(cities)
                compilation(state)
            } catch {
                compilation(state)
            }
        }
    }
    
    private func getCityObjects(_ models: [CityModelResponse]) -> [City] {
        var buffer : [City] = []
        models.forEach {
            let city = CityFactory.createCity($0)
            buffer.append(city)
        }
        
        return buffer
    }
}
