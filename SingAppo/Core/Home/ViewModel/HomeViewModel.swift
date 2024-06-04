//
//  HomeViewModel.swift
//  SingAppo
//
//  Created by Zachary on 29/5/24.
//

import Foundation

@Observable final class HomeViewModel {
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
}
