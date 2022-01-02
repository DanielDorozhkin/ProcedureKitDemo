//
//  UIViewController + Alert.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func appearAlert(_ text: String) {
        let alert = UIAlertController()
        let action = UIAlertAction(title: "Okey", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}
