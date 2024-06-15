//
//  WishlistViewModel.swift
//  SingAppo
//
//  Created by Zachary on 13/6/24.
//

import Foundation
import Combine

@MainActor
final class WishlistViewModel: ObservableObject {
    
    @Published private(set) var userWishlistProducts: [UserWishlistProduct] = []
    private var cancellables = Set<AnyCancellable>()
    
    func addListenerForWishlist() {
        Task {
            let authDataRes = try AuthenticationManager.shared.getAuthenticatedUser()
            //            UserManager.shared.addListenerUserWishlistProducts(userId: authDataRes.uid) { [weak self] products in
            //                self?.userWishlistProducts = products
            //        }
            
            UserManager.shared.addListenerUserWishlistProducts(userId: authDataRes.uid)
                .sink { completion in
                    
                } receiveValue: { [weak self] products in
                    self?.userWishlistProducts = products
                }
                .store(in: &cancellables)
            
        }
    }
    
    
    //    func getWishlist() {
    //        Task {
    //            let authDataRes = try AuthenticationManager.shared.getAuthenticatedUser()
    //            self.userWishlistProducts = try await UserManager.shared.getAllUserWishlistProducts(userId: authDataRes.uid)
    //        }
    //    }
    
    func removeFromWishlist(wishlistProductId: String) {
        Task {
            let authDataRes = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserWishlistProduct(userId: authDataRes.uid, wishlistProductId: wishlistProductId)
            //            getWishlist()
        }
    }
    
}
