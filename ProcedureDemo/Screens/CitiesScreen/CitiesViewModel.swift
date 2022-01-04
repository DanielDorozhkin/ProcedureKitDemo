//
//  CitiesViewModel.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation

//MARK: -Source
final class CitiesViewModel {
    private let requestedCountry  : Country
    private let network           : NetworkService
    private let coordinator       : Coordinator
    private var citiesSource = [State]()
    
    weak var citiesDelegate       : ScreenStateProtocol?
    
    init(country: Country, network: NetworkService, coordinator: Coordinator) {
        self.requestedCountry = country
        self.network          = network
        self.coordinator      = coordinator
    }
    
    func viewWillAppear() {
        requestCities()
    }
    
    private func requestCities() {
        coordinator.updateNavigationTitle(requestedCountry.name)
        citiesDelegate?.updateScreenState(to: .loading)
        
        network.requestCities(requestedCountry) { states in
            if let states = states {
                self.citiesSource = states
                self.citiesDelegate?.updateScreenState(to: .loaded)
            } else {
                self.citiesDelegate?.updateScreenState(to: .error)
            }
        }
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
    
    func getCityObjectForCell(for indexPath: IndexPath) -> City? {
        let state = citiesSource.getItemFor(index: indexPath.section) as? State
        let city = state?.cities.getItemFor(index: indexPath.row) as? City
        
        return city
    }
}
