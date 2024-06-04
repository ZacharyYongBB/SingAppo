//
//  AuthenticationView.swift
//  SingAppo
//
//  Created by Zachary on 4/6/24.
//

import SwiftUI

struct AuthenticationView: View {
    
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
