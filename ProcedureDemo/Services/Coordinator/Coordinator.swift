//
//  Coordinator.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation
import UIKit

//MARK: -Source
final class Coordinator: NSObject {
    private let navigationController : UINavigationController
    private let network              : NetworkService
    
    init(_ navigationController: UINavigationController, network: NetworkService) {
        self.navigationController = navigationController
        self.network = network
        super.init()
        
        navigationController.delegate = self
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
    
    func updateNavigationTitle(_ title: String) {
        guard let currentVC = navigationController.topViewController else { return }
        currentVC.title = title
    }
}

//MARK: -Animation
extension Coordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = FadeAnimation()
        animation.setTransitionType(isPush: operation == .push)
        
        return animation
    }
}
