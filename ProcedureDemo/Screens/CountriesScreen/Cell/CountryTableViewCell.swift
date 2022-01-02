//
//  CountryTableViewCell.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import UIKit
import Reusable

class CountryTableViewCell: UITableViewCell, NibReusable {
    
    //MARK: -Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    func configure(_ country: Country) {
        nameLabel.text = country.name
        codeLabel.text = country.code
    }
}
