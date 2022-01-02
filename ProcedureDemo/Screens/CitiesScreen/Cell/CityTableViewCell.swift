//
//  CityTableViewCell.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import UIKit
import Reusable

final class CityTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var cityNameLabel: UILabel!
    
    func configure(_ city: City) {
        self.cityNameLabel.text = city.name
    }
}
