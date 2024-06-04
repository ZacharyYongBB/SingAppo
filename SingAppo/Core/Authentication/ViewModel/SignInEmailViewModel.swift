//
//  SignInEmailViewModel.swift
//  SingAppo
//
//  Created by Zachary on 4/6/24.
//

import Foundation
import Observation

@Observable class SignInEmailViewModel {
    
    var email = ""
    var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password entered")
            return
        }
        
        let _ = try await AuthenticationManager.shared.createUser(email: email, password: password)        
        
    }
    
}
