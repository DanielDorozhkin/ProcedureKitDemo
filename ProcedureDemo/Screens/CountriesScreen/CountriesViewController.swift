//
//  CountriesViewController.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import UIKit

class CountriesViewController: UIViewController {
    
    //MARK: -Outlets
    @IBOutlet weak var countriesTableView: UITableView!
    
    private let viewModel : CountryViewModel
    
    //MARK: -Init
    init(_ viewModel: CountryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        fatalError()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionSetup()
        viewModel.getCountries()
    }
    
    //MARK: -Configure
    private func collectionSetup() {
        countriesTableView.delegate   = self
        countriesTableView.dataSource = self
        
        countriesTableView.register(cellType: CountryTableViewCell.self)
    }
}

//MARK: -Screen protocol
extension CountriesViewController: ScreenStateProtocol {
    func sourceState() {
        DispatchQueue.main.async {
            self.countriesTableView.reloadData()
        }
    }
    
    func errorState() {
        self.appearAlert("Error connection")
    }
}

//MARK: -Table View
extension CountriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CountryTableViewCell = countriesTableView.dequeueReusableCell(for: indexPath)
        let country = viewModel.countriesSource[indexPath.row]
        
        cell.configure(country)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countriesTableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRowAt(indexPath: indexPath)
    }
}
