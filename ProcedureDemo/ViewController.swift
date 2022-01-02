//
//  ViewController.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 30/12/2021.
//

import UIKit
import ProcedureKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createQueue()
    }

    func createQueue() {
        let queue = ProcedureQueue()
        
        let setter = SetterProcedure()
        let age = AgeProcedure()
        let formatter = FormatProcedure()
        
        age.injectResult(from: setter)
        formatter.injectResult(from: age)
        
        let group = GroupProcedure(operations: setter, age, formatter)
        queue.addOperation(group)
    }
}

class SetterProcedure: Procedure, OutputProcedure {
    var output : Pending<ProcedureResult<Int>> = .pending
    
    override func execute() {
        let age : Int = 15
        output = .ready(.success(age))
        
        finish()
    }
    
    private func capitalized(_ string: String) -> String {
        return string.capitalized
    }
}

class AgeProcedure: Procedure, InputProcedure, OutputProcedure {
    var input: Pending<Int> = .pending
    var output: Pending<ProcedureResult<String>> = .pending
    
    override func execute() {
        guard let age = input.value else { return }
        let string = ageFormat(age)
        output = .ready(.success(string))
        
        finish()
    }
    
    func ageFormat(_ age: Int) -> String {
        return String("i'm \(age) years old")
    }
}

class FormatProcedure: Procedure, InputProcedure, OutputProcedure {
    var input: Pending<String> = .pending
    var output: Pending<ProcedureResult<String>> = .pending
    
    override func execute() {
        guard let string = input.value else { return }
        let formatted = capitalize(string)
        output = .ready(.success(formatted))
        print(output)
        finish()
    }
    
    private func capitalize(_ string: String) -> String {
        return string.capitalized
    }
}
