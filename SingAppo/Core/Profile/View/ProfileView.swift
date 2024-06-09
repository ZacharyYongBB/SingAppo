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
    
    @MainActor
    func togglePremiumStatus() async throws {
        guard let user else { return }
        let currentPremiumStatus = user.isPremium ?? false
        
        Task {
            try await UserManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currentPremiumStatus)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func addUserPreference(text: String) {
        guard let user else { return }
        
        Task {
            try await UserManager.shared.addUserPreference(userId: user.userId, preference: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func removeUserPreference(text: String) {
        guard let user else { return }
        
        Task {
            try await UserManager.shared.removeUserPreference(userId: user.userId, preference: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func addFavouriteMovie() {
        guard let user else { return }
        let movie = Movie(id: "1", title: "Hello World Movie", isPopular: true)
        Task {
            try await UserManager.shared.addFavouriteMovie(userId: user.userId, movie: movie)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func removeFavouriteMovie() {
        guard let user else { return }
        Task {
            try await UserManager.shared.removeFavouriteMovie(userId: user.userId)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    
}

struct ProfileView: View {
    
    @State private var vm = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    let preferenceOptions: [String] = ["Sports", "Movies", "Books", "Games", "Travel"]
    private func preferenceIsSelected(text: String) -> Bool {
        vm.user?.preferences?.contains(text) == true
    }
    
    var body: some View {
        NavigationStack {
            List {
                if let user = vm.user {
                    Text("User ID: \(user.userId)")
                    
                    if let isAnonymous = user.isAnonymous {
                        Text("Is Anonymous: \(isAnonymous.description)")
                    }
                    Button {
                        Task {
                            try? await vm.togglePremiumStatus()
                        }
                    } label: {
                        Text("User is premium: \(user.isPremium ?? false)")
                    }
                    
                    VStack {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                            ForEach(preferenceOptions, id: \.self) { pref in
                                Button(pref) {
                                    if preferenceIsSelected(text: pref) {
                                        vm.removeUserPreference(text: pref)
                                    } else {
                                        vm.addUserPreference(text: pref)
                                    }
                                }
                                .font(.headline)
                                .buttonStyle(.borderedProminent)
                                .tint(preferenceIsSelected(text: pref) ? .green : .red)
                            }
                        }
                        
                        Text("User preferences: \((user.preferences ?? []).joined(separator: ", "))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        if user.favouriteMovie == nil {
                            vm.addFavouriteMovie()
                        } else {
                            vm.removeFavouriteMovie()
                        }
                    } label: {
                        Text("Favourite Movie: \(user.favouriteMovie?.title ?? "")")
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
//
//#Preview {
//    NavigationStack {
//        ProfileView(showSignInView: .constant(false))
//    }
//}

#Preview {
    NavigationStack {
        RootView()
    }
}
