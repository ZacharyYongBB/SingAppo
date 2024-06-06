//
//  AuthenticationView.swift
//  SingAppo
//
//  Created by Zachary on 4/6/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift


struct AuthenticationView: View {
    
    @StateObject private var vm = AuthenticationViewModel()
    @Environment(\.router) var router
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            Spacer()
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
            
            Button {
                Task {
                    do {
                        try await vm.signInAnonymous()
                        showSignInView = false
                    } catch {
                        // TODO: handle error
                        print(error)
                    }
                }
            } label: {
                Text("Sign in Anonymously")
                    .primaryButton(color: Color.teal)
            }
            
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
