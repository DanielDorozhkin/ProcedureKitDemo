//
//  CountryViewModel.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation

//MARK: -Protocols
protocol ScreenStateProtocol: AnyObject {
    func sourceState()
    func errorState()
    func isLoadingStateAppearing(_ appear: Bool)
}

//MARK: -Source
final class CountryViewModel {
    private let network              : NetworkService
    private let coordinator          : Coordinator
    private(set) var countriesSource = [Country]()
    
    weak var countryDelegate         : ScreenStateProtocol?
    
    init(_ network: NetworkService, coordinator: Coordinator) {
        self.network = network
        self.coordinator = coordinator
    }
    
    func getCountries() {
        countryDelegate?.isLoadingStateAppearing(true)
        coordinator.updateNavigationTitle("Countries")
        
        network.requestCountries { [weak self] countries in
            guard let self = self else { return }
            if let countries = countries {
                self.countriesSource = countries
                self.countryDelegate?.sourceState()
            } else {
                self.countryDelegate?.errorState()
            }
            
            self.countryDelegate?.isLoadingStateAppearing(false)
        }
    }
}

//MARK: -Table view
extension CountryViewModel {
    func numberOfItemsInSection(section: Int) -> Int {
        return countriesSource.count
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        let country = countriesSource[indexPath.row]
        coordinator.pushCitiesScreen(country)
    }
}
