//
//  CountryViewModel.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation

//MARK: -Protocols
protocol ScreenStateProtocol: AnyObject {
    func updateScreenState(to: ScreenState)
}

enum ScreenState {
    case loading
    case loaded
    case error
}

//MARK: -Source
final class CountryViewModel {
    private let network              : NetworkService
    private let coordinator          : Coordinator
    private var countriesSource = [Country]()
    
    weak var countryDelegate         : ScreenStateProtocol?
    
    init(_ network: NetworkService, coordinator: Coordinator) {
        self.network = network
        self.coordinator = coordinator
    }
    
    func viewDidLoad() {
        getCountries()
    }
    
    private func getCountries() {
        countryDelegate?.updateScreenState(to: .loading)
        coordinator.updateNavigationTitle("Countries")
        
        network.requestCountries { [weak self] countries in
            guard let self = self else { return }
            if let countries = countries {
                self.countriesSource = countries
                self.countryDelegate?.updateScreenState(to: .loaded)
            } else {
                self.countryDelegate?.updateScreenState(to: .error)
            }
        }
    }
}

//MARK: -Table view
extension CountryViewModel {
    func numberOfItemsInSection(section: Int) -> Int {
        return countriesSource.count
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        guard countriesSource.indices.contains(indexPath.row) else { return }
        
        let country = countriesSource[indexPath.row]
        coordinator.routeToCityListScreen(country)
    }
    
    func getCellCountryObject(for indexPath: IndexPath) -> Country? {
        let country = countriesSource.getItemFor(index: indexPath.row) as? Country
        return country
    }
}
