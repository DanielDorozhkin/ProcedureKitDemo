//
//  Coordinator.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation
import UIKit

class Coordinator {
    let navigationController : UINavigationController
    private let network      = NetworkService.shared
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let countryViewModel = CountryViewModel(network, coordinator: self)
        let countryVC        = CountriesViewController(countryViewModel)
        countryViewModel.countryDelegate = countryVC
        
        applyTransitionAnimation()
        navigationController.pushViewController(countryVC, animated: false)
    }
    
    func pushCitiesScreen(_ country: Country) {
        let citiesViewModel = CitiesViewModel(country: country, network: network, coordinator: self)
        let citiesVC        = CitiesViewController(citiesViewModel)
        citiesViewModel.citiesDelegate = citiesVC
        
        applyTransitionAnimation()
        navigationController.pushViewController(citiesVC, animated: false)
    }
    
    func pop() {
        navigationController.popViewController(animated: false)
    }
    
    private func applyTransitionAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        navigationController.view.layer.add(transition, forKey: nil)
    }
}
