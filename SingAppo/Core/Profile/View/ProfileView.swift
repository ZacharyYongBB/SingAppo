//
//  ProfileView.swift
//  SingAppo
//
//  Created by Zachary on 7/6/24.
//

import SwiftUI

@Observable class ProfileViewModel {
    
    private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataRes = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataRes.uid)
    }
    
}

struct ProfileView: View {
    
    @State private var vm = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            List {
                if let user = vm.user {
                    Text("User ID: \(user.userId)")
                    
                    if let isAnonymous = user.isAnonymous {
                        Text("Is Anonymous: \(user.isAnonymous?.description ?? "")")
                    }
                    
                }
            }
            .onAppear {
                Task {
                    try? await vm.loadCurrentUser()
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView(showSignInView: $showSignInView)
                    } label: {
                        HStack {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .font(.headline)
                    }
                    
                }
            }
        }
        
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}
