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
    required init(_ viewModel: CitiesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        
        viewModel.viewWillAppear()
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
            self.citiesTableView.reloadData()
        }
    }
    
    private func errorState() {
        DispatchQueue.main.async {
            self.appearAlert("No information found", action: { [weak self] _ in
                self?.viewModel.popScreen()
            })
        }
    }
    
    private func isLoadingStateAppearing(_ appear: Bool) {
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
        guard let city = viewModel.getCityObjectForCell(for: indexPath) else {
            return UITableViewCell()
        }
        let cell : CityTableViewCell = citiesTableView.dequeueReusableCell(for: indexPath)
        
        cell.configure(city)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        citiesTableView.deselectRow(at: indexPath, animated: true)
    }
}
