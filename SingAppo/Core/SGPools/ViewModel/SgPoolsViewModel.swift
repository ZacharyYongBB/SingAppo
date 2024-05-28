//
//  SgPoolsViewModel.swift
//  SingAppo
//
//  Created by Zachary on 28/5/24.
//

import Foundation

class SgPoolsViewModel: ObservableObject {
    
    func generateToto(system: Int) -> [Int] {
        var numbers = Set<Int>()
        
        while numbers.count < system {
            let randomNumber = Int.random(in: 1...49)
            numbers.insert(randomNumber)
        }
        
        return Array(numbers).sorted()
    }
    
    func generate4D() -> String {
        let randomNumber = Int.random(in: 0...9999)
        return String(format: "%04d", randomNumber)
    }
    
}
