//
//  AuthenticationManager.swift
//  SingAppo
//
//  Created by Zachary on 4/6/24.
//

import Foundation
import FirebaseAuth

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() {
        
    }
    
    func getAuthenticatedUser() throws -> AuthDataResModel {
        guard let user = Auth.auth().currentUser else {
            throw ErrorMessage.invalidResponse
        }
        
        return AuthDataResModel(user: user)
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResModel {
        let authDataRes =  try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResModel(user: authDataRes.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
}
