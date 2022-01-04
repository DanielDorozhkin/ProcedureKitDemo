//
//  ArrayIndexSafer.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 04/01/2022.
//

import Foundation

extension Array {
    func getItemFor(index: Int) -> AnyObject? {
        if index >= self.count {
            return nil
        }
        
        return self[index] as AnyObject
    }
}
