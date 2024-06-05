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
    
    @Binding var listItems: [(String, AnyView, Bool)]
    @State private var vm = SettingsViewModel()
    @State private var updateEmailField = ""
    @State private var updatePasswordField = ""
    @State var isShowingAccountSetting = false
    
    
    
    var body: some View {
        VStack {
            List {
                ForEach(0..<listItems.count, id: \.self) { index in
                    Toggle(isOn: Binding(
                        get: { listItems[index].2 },
                        set: { listItems[index].2 = $0 }
                    )) {
                        Text(listItems[index].0)
                    }
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
}
