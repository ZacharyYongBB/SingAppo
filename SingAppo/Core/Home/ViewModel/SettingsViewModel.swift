//
//  SettingsViewModel.swift
//  SingAppo
//
//  Created by Zachary on 29/5/24.
//

import Foundation

@Observable final class SettingsViewModel {
    
    var authProviders: [AuthProviderOption] = []
    var authUser: AuthDataResModel? = nil
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func loadAuthUser() {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws{
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw ErrorMessage.noEmailFound
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail(email: String) async throws {
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword(password: String) async throws {
        try await AuthenticationManager.shared.updatePassword(password: password)   
    }
    
    func linkGoogleAccount() async throws {
        let helper = SignInWithGoogleHelper(GIDClientID: GID_CLIENT_ID)
        let tokens = try await helper.signIn()
        self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
    }
    
    func linkAppleAccount() async throws {
        let helper = await SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        self.authUser = try await AuthenticationManager.shared.linkApple(tokens: tokens)
    }
    
    func linkEmailAccount(email: String, password: String) async throws {
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
    }
    
}
