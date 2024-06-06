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
    
    func getProviders() throws -> [AuthProviderOption]{
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw ErrorMessage.invalidUser
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        
        return providers
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
}




// MARK: Sign in EMAIL
extension AuthenticationManager {
    
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


// MARK: Sign in SSO
extension AuthenticationManager {
    
    
    func signIn(credentials: AuthCredential) async throws -> AuthDataResModel {
        let authDataRes = try await Auth.auth().signIn(with: credentials)
        return AuthDataResModel(user: authDataRes.user)
    }
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResult) async throws -> AuthDataResModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credentials: credential)
    }
    
    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResModel {
        let credential = OAuthProvider.credential(
            withProviderID: AuthProviderOption.apple.rawValue,
            idToken: tokens.token,
            rawNonce: tokens.nonce
        )
        return try await signIn(credentials: credential)
    }
    
    
}

// https://singappo-7b8ba.firebaseapp.com/__/auth/handler
