//
//  UIViewController + Alert.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func appearAlert(_ text: String, action: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: action))
        self.present(alert, animated: true, completion: nil)
    }
}
