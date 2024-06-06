//
//  AuthenticationView.swift
//  SingAppo
//
//  Created by Zachary on 4/6/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthenticationViewModel: ObservableObject {
        
    func signInGoogle() async throws {
        let helper = SignInWithGoogleHelper(GIDClientID:"318664637842-sabocdki9h5l82i6s2tf0dfn7ojmprae.apps.googleusercontent.com")
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
    
    func signInApple() async throws {
        
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        
    }
    
}



struct AuthenticationView: View {
    
    @StateObject private var vm = AuthenticationViewModel()
    @Environment(\.router) var router
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            NavigationLink {
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign in With Email")
                    .primaryButton()
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await vm.signInGoogle()
                        showSignInView = false
                    } catch {
                        // TODO: handle error
                        print(error)
                    }
                }
            }
            
            Button {
                Task {
                    do {
                        try await vm.signInApple()
                        showSignInView = false
                    } catch {
                        // TODO: handle error
                        print(error)
                    }
                }
            } label: {
                SignInWithAppleViewRepresentable(
                    type: .default,
                    style: .black
                )
                .allowsHitTesting(false)
            }
            .frame(height: 45)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }
}
