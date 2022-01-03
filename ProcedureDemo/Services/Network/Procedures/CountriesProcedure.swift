//
//  CountriesProcedure.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation
import Alamofire
import ProcedureKit

final class CountriesGroupProcedure: GroupProcedure, InputProcedure, OutputProcedure {
    var input : Pending<String>                     = .pending
    var output: Pending<ProcedureResult<[Country]>> = .pending
    
    init(_ network: NetworkService) {
        let authProcedure      = AuthProcedure(network)
        let countriesProcedure = CountriesProcedure(network).injectResult(from: authProcedure)
        
        super.init(operations: [authProcedure, countriesProcedure])
        
        bind(from: countriesProcedure)
    }
}

private final class CountriesProcedure: Procedure, InputProcedure, OutputProcedure {
    var input : Pending<String>                     = .pending
    var output: Pending<ProcedureResult<[Country]>> = .pending
    
    private let network : NetworkService
    
    init(_ network: NetworkService) {
        self.network = network
        super.init()
    }
    
    override func execute() {
        getCountries { countries in
            if let countries = countries {
                self.output = .ready(.success(countries))
            } else {
                self.cancel()
            }
            
            self.finish()
        }
    }
    
    private func getCountries(_ compilation: @escaping ([Country]?) -> Void) {
        guard let headers = network.getHeaders() else { return }
        let url = "https://www.universal-tutorial.com/api/countries"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).response { [weak self] data in
            guard let self = self else { return }
            guard let data = data.data else {
                compilation(nil)
                return
            }
            
            do {
                let countryModels = try JSONDecoder().decode([CountryModelResponse].self, from: data)
                let countries     = self.getCountriesObjects(countryModels)
                
                compilation(countries)
            } catch {
                compilation(nil)
            }
        }
    }
    
    private func getCountriesObjects(_ models: [CountryModelResponse]) -> [Country] {
        var buffer : [Country] = []
        models.forEach {
            let country = CountryFactory.createCountry($0)
            buffer.append(country)
        }
        
        return buffer
    }
}

