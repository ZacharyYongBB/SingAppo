//
//  SettingsViewModel.swift
//  SingAppo
//
//  Created by Zachary on 29/5/24.
//

import Foundation

@Observable final class SettingsViewModel {
    
    var authProviders: [AuthProviderOption] = []
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
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
        try await AuthenticationManager.shared.updatePassword(password: password)    }
    
}
