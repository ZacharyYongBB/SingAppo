//
//  ProfileViewModel.swift
//  SingAppo
//
//  Created by Zachary on 19/6/24.
//

import Foundation
import SwiftUI
import PhotosUI

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
    
    func saveProfileImage(item: PhotosPickerItem) {
        
        Task {
            guard let data = try await item.loadTransferable(type: Data.self), let user else { return }
            let (path, name) = try await StorageManager.shared.saveImage(data: data, userId: user.userId)
            print("success save image")
            print(path)
            print(name)
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: path, url: url.absoluteString)
        }
        
    }
    
    func deleteProfileImage() {
        
        guard let user, let path = user.profileImagePath else { return }
        
        Task {
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: nil, url: nil)
        }
        
    }
    
}
