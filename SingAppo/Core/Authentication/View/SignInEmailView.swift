//
//  SignInEmailView.swift
//  SingAppo
//
//  Created by Zachary on 4/6/24.
//

import SwiftUI

struct SignInEmailView: View {
    
    @State private var vm = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TextField("Enter Email", text: $vm.email)
                .primaryTextField()
            SecureField("Enter Password", text: $vm.password)
                .primaryTextField()
            Button {
                Task {
                    do {
                        try await vm.signUp()
                        showSignInView = false
                        print("signup")
                        return
                    } catch {
                        // TODO: handle error
                        print(error)
                    }
                    
                    do {
                        try await vm.signIn()
                        showSignInView = false
                        print("sign in")
                        return
                    } catch {
                        // TODO: handle error
                        print(error)
                    }

                }
            } label: {
                Text("Sign In")
                    .primaryButton()
            }
        }
        .padding()
        .navigationTitle("Sign in With Email")
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}
