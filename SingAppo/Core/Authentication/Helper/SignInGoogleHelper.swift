//
//  SignInGoogleHelper.swift
//  SingAppo
//
//  Created by Zachary on 5/6/24.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

final class SignInGoogleHelper {

    @MainActor
    func signIn() async throws -> GoogleSignInResModel {
        
        guard let topVC = TopViewController.shared.topViewController() else {
            throw ErrorMessage.unableToComplete
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw ErrorMessage.invalidResponse
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString
        let name = gidSignInResult.user.profile?.name
        let email = gidSignInResult.user.profile?.email
        
        let tokens = GoogleSignInResModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
        return tokens
        
    }
    
}
