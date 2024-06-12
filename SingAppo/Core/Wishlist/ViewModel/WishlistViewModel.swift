//
//  WishlistViewModel.swift
//  SingAppo
//
//  Created by Zachary on 13/6/24.
//

import Foundation

@MainActor
final class WishlistViewModel: ObservableObject {
    
    @Published private(set) var userWishlistProducts: [UserWishlistProduct] = []
    
    
    func getWishlist() {
        Task {
            let authDataRes = try AuthenticationManager.shared.getAuthenticatedUser()
            self.userWishlistProducts = try await UserManager.shared.getAllUserWishlistProducts(userId: authDataRes.uid)
        }
    }
    
    func removeFromWishlist(wishlistProductId: String) {
        Task {
            let authDataRes = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserWishlistProduct(userId: authDataRes.uid, wishlistProductId: wishlistProductId)
            getWishlist()
        }
    }
    
}
