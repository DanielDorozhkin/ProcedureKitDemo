//
//  CountriesViewController.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import UIKit

final class CountriesViewController: UIViewController {
    
    //MARK: -Outlets
    @IBOutlet private weak var countriesTableView : UITableView!
    @IBOutlet private weak var loadingIndicator   : UIActivityIndicatorView!
    
    private let viewModel : CountryViewModel
    
    //MARK: -Init
    required init(_ viewModel: CountryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableSetup()
        viewModel.viewDidLoad()
    }
    
    //MARK: -Configure
    private func tableSetup() {
        countriesTableView.delegate   = self
        countriesTableView.dataSource = self
        
        countriesTableView.register(cellType: CountryTableViewCell.self)
    }
}

//MARK: -Screen protocol
extension CountriesViewController: ScreenStateProtocol {
    func updateScreenState(to: ScreenState) {
        switch to {
        case .loading:
            isLoadingStateAppearing(true)
            
        case .loaded:
            isLoadingStateAppearing(false)
            sourceState()
            
        case .error:
            isLoadingStateAppearing(false)
            errorState()
        }
    }
    
    private func sourceState() {
        DispatchQueue.main.async {
            self.countriesTableView.reloadData()
        }
    }
    
    private func errorState() {
        DispatchQueue.main.async {
            self.appearAlert("Connection troubles", action: { _ in })
        }
    }
    
    private func isLoadingStateAppearing(_ appear: Bool) {
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden   = !appear
            self.countriesTableView.isHidden =  appear
            
            self.loadingIndicator.startAnimating()
        }
    }
}

//MARK: -Table View
extension CountriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let country = viewModel.getCellCountryObject(for: indexPath) else {
            return UITableViewCell()
        }
        let cell : CountryTableViewCell = countriesTableView.dequeueReusableCell(for: indexPath)
        
        cell.configure(country)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countriesTableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRowAt(indexPath: indexPath)
    }
}
