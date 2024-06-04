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
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResModel {
        let authDataRes =  try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResModel(user: authDataRes.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResModel {
        let authDataRes =  try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResModel(user: authDataRes.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw ErrorMessage.invalidUser
        }
        
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw ErrorMessage.invalidUser
        }
        
        try await user.sendEmailVerification(beforeUpdatingEmail: email)
    }
    
}
