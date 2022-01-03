//
//  NetworkService.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation
import Alamofire
import ProcedureKit

final class NetworkService {
    static  let shared    = NetworkService()
    private var authToken : String?
    
    private init() { }
    
    func requestCountries(_ compilation: @escaping ([Country]?) -> Void) {
        let queue          = ProcedureQueue()
        let countriesGroup = CountriesGroupProcedure(self)
        
        countriesGroup.addDidFinishBlockObserver { group, error in
            if let countries = group.output.value?.value {
                compilation(countries)
            } else {
                compilation(nil)
            }
        }
        
        queue.addOperation(countriesGroup)
    }
    
    func requestCities(_ country: Country, _ compilation: @escaping ([State]?) -> Void) {
        let queue       = ProcedureQueue()
        let citiesGroup = CitiesProcedureGroup(country, network: self)
        
        citiesGroup.addDidFinishBlockObserver { group, error in
            if let cities = group.output.value?.value {
                compilation(cities)
            } else {
                compilation(nil)
            }
        }
        
        queue.addOperation(citiesGroup)
    }
    
    func getHeaders() -> HTTPHeaders? {
        guard let token = self.authToken else { return nil }
        let headers : HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": token
        ]
        
        return headers
    }
    
    func setAuthKey(_ key: String) {
        self.authToken = key
    }
}
