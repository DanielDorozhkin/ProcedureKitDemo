//
//  CitiesViewModel.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation

//MARK: -Source
class CitiesViewModel {
    private let requestedCountry  : Country
    private let network           : NetworkService
    private let coordinator       : Coordinator
    private(set) var citiesSource = [State]()
    weak var citiesDelegate       : ScreenStateProtocol?
    
    init(country: Country, network: NetworkService, coordinator: Coordinator) {
        self.requestedCountry = country
        self.network          = network
        self.coordinator      = coordinator
    }
    
    func requestCities() {
        network.getCities(requestedCountry) { states in
            self.citiesSource = states
            self.citiesDelegate?.sourceState()
        }
    }
}

//MARK: -Table view
extension CitiesViewModel: TableViewProtocol {
    func numberOfSections() -> Int {
        return citiesSource.count
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        let state = citiesSource[section]
        return state.cities.count
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        
    }
}
