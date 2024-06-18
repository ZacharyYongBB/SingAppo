//
//  ProfileView.swift
//  SingAppo
//
//  Created by Zachary on 7/6/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @State private var vm = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var profilePicUrl: URL? = nil
    
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
                    
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text("Select Photo")
                        }
                }
                
                if let urlString = vm.user?.profileImagePathUrl, let url = URL(string: urlString)
                {
                    HStack {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 150, height: 150)
                        }
                        ImageLoaderView(urlString: urlString, resizeMode: .fill)
                    }
                    
                    if vm.user?.profileImagePath != nil {
                        Button("Delete Image") {
                            vm.deleteProfileImage()
                        }
                    }
                    
                }
                
                
            }
            .task {
                try? await vm.loadCurrentUser()
                
            }
            .onChange(of: selectedItem, { _, newValue in
                if let newValue {
                    vm.saveProfileImage(item: newValue)
                }
            })
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
