//
//  CitiesViewController.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import UIKit

final class CitiesViewController: UIViewController {

    //MARK: -Outlets
    @IBOutlet private weak var citiesTableView : UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    private let viewModel : CitiesViewModel
    
    //MARK: -Init
    init(_ viewModel: CitiesViewModel) {
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

        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.requestCities()
    }
    
    //MARK: -Configure
    private func setupTable() {
        citiesTableView.delegate   = self
        citiesTableView.dataSource = self
        
        citiesTableView.register(cellType: CityTableViewCell.self)
    }
}

//MARK: -Screen state protocol
extension CitiesViewController: ScreenStateProtocol {
    func sourceState() {
        DispatchQueue.main.async {
            self.citiesTableView.reloadData()
        }
    }
    
    func errorState() {
        DispatchQueue.main.async {
            self.appearAlert("No information found", action: { [weak self] _ in
                self?.viewModel.popScreen()
            })
        }
    }
    
    func isLoadingStateAppearing(_ appear: Bool) {
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = !appear
            self.citiesTableView.isHidden  =  appear
            
            self.loadingIndicator.startAnimating()
        }
    }
}

//MARK: -Table view
extension CitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView : UITableView, titleForHeaderInSection section: Int)->String? {
        return viewModel.titleForSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CityTableViewCell = citiesTableView.dequeueReusableCell(for: indexPath)
        let city = viewModel.citiesSource[indexPath.section].cities[indexPath.row]
        
        cell.configure(city)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        citiesTableView.deselectRow(at: indexPath, animated: true)
    }
}
