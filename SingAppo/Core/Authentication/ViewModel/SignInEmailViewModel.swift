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
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password entered")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
        
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password entered")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
    }
    
    
}