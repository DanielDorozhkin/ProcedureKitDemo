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
        citiesDelegate?.isLoadingStateAppearing(true)
        updateNavigationTitle()
        
        network.getCities(requestedCountry) { states in
            if let states = states {
                self.citiesSource = states
                self.citiesDelegate?.sourceState()
            } else {
                self.citiesDelegate?.errorState()
            }
            
            self.citiesDelegate?.isLoadingStateAppearing(false)
        }
    }
    
    private func updateNavigationTitle() {
        guard let currentVC = coordinator.navigationController.topViewController else { return }
        currentVC.title = requestedCountry.name
    }
    
    func popScreen() {
        coordinator.pop()
    }
}

//MARK: -Table view
extension CitiesViewModel {
    func numberOfSections() -> Int {
        return citiesSource.count
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        let state = citiesSource[section]
        return state.cities.count
    }
    
    func titleForSection(section: Int) -> String {
        let state = citiesSource[section]
        return state.name
    }
}
