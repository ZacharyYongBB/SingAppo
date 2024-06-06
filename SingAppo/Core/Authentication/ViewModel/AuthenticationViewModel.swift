//
//  AuthenticationViewModel.swift
//  SingAppo
//
//  Created by Zachary on 7/6/24.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle() async throws {
        let helper = SignInWithGoogleHelper(GIDClientID: GID_CLIENT_ID)
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
    }
    
    func signInAnonymous() async throws {
        try await AuthenticationManager.shared.signInAnonymous()
    }
    
}
