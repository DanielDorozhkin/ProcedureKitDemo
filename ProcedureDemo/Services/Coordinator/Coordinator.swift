//
//  Coordinator.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation
import UIKit

class Coordinator {
    private let navigationController : UINavigationController
    private let network              = NetworkService.shared
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let countryViewModel = CountryViewModel(network, coordinator: self)
        let countryVC        = CountriesViewController(countryViewModel)
        countryViewModel.countryDelegate = countryVC
        
        navigationController.pushViewController(countryVC, animated: true)
    }
    
    func pushCitiesScreen(_ country: Country) {
        let citiesViewModel = CitiesViewModel(country: country, network: network, coordinator: self)
        let citiesVC        = CitiesViewController(citiesViewModel)
        citiesViewModel.citiesDelegate = citiesVC
        
        navigationController.pushViewController(citiesVC, animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}
