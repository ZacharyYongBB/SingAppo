//
//  SettingsView.swift
//  SingAppo
//
//  Created by Zachary on 29/5/24.
//

import SwiftUI
import SwiftfulRouting

struct SettingsView: View {
    
    @Environment(\.router) var router
    
//    @Binding var listItems: [(String, AnyView, Bool)]
    @Binding var showSignInView: Bool
    @State private var vm = SettingsViewModel()
    @State private var updateEmailField = ""
    @State private var updatePasswordField = ""
    @State var isShowingAccountSetting = false
    
    
    
    var body: some View {
        VStack {
            List {
                Button {
                    Task {
                        do {
                            try vm.logOut()
                            showSignInView = true
                        } catch {
                            // TODO: handle error
                            print(error)
                        }
                    }
                } label: {
                    Text("Log Out")
                }
                
                Button(role: .destructive) {
                    Task {
                        do {
                            // probably ask user if they are sure
                            //                            router.showScreen(.push) {
                            //                                 on dismiss callback to confirm if they are really authenticated
                            //                            } destination: { _ in
                            //                                ConfirmDeleteScreen()
                            //                            }
                            
                            try await vm.deleteAccount()
                            showSignInView = true
                        } catch {
                            // TODO: handle error
                            print(error)
                        }
                    }
                } label: {
                    Text("Delete Account")
                }
//                ForEach(0..<listItems.count, id: \.self) { index in
//                    Toggle(isOn: Binding(
//                        get: { listItems[index].2 },
//                        set: { listItems[index].2 = $0 }
//                    )) {
//                        Text(listItems[index].0)
//                    }
//                }
                if vm.authUser?.isAnonymous == true {
                    anonymousSection
                }
            }
            if vm.authProviders.contains(.email) {
                Button {
                    router.showScreen(.sheet) { _ in
                        accountSettings
                    }
                } label: {
                    Text("Account Settings")
                        .primaryButton()
                        .padding(.horizontal)
                }
                
            }
            
        }
        .onAppear {
            vm.loadAuthProviders()
            vm.loadAuthUser()
        }
        .navigationTitle("Settings")
    }
}

extension SettingsView {
    
    
    private var accountSettings: some View {
        VStack {
            Spacer()
            Button {
                Task {
                    do {
                        try await vm.resetPassword()
                    } catch {
                        // TODO: handle error
                        print(error)
                    }
                }
            } label: {
                Text("Reset Password")
                    .primaryButton()
            }
            
            Spacer()
            
            TextField("Enter new Email", text: $updateEmailField)
                .primaryTextField()
            
            Button {
                Task {
                    do {
                        try await vm.updateEmail(email: updateEmailField)
                    } catch {
                        // TODO: handle error
                        print(error)
                    }
                }
            } label: {
                Text("Update Email")
                    .primaryButton()
            }
            
            Spacer()
            
            
            SecureField("Enter new Email", text: $updatePasswordField)
                .primaryTextField()
            
            Button {
                Task {
                    do {
                        try await vm.updatePassword(password: updatePasswordField)
                    } catch {
                        // TODO: handle error
                        print(error)
                    }
                }
            } label: {
                Text("Update Password")
                    .primaryButton()
            }
            
            Spacer()
            
        }
        .padding(20)
    }
    
    private var anonymousSection: some View {
        Section {
            Button("Link Google Account") {
                Task {
                    do {
                        try await vm.linkGoogleAccount()
                    } catch {
                        print(error)
                        // TODO: handle error
                    }
                }
            }
            Button("Link Apple Account") {
                Task {
                    do {
                        try await vm.linkAppleAccount()
                    } catch {
                        print(error)
                        // TODO: handle error
                    }
                }
            }
            Button("Link Email Account") {
                Task {
                    do {
                        try await vm.linkEmailAccount(email: "hello@abc.com", password: "aaaaaa")
                    } catch {
                        print(error)
                        // TODO: handle error
                    }
                }
            }
        } header: {
            Text("Create Account")
        }
    }
}

