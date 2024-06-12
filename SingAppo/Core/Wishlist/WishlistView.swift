//
//  WishlistView.swift
//  SingAppo
//
//  Created by Zachary on 12/6/24.
//

import SwiftUI

@MainActor
final class WishlistViewModel: ObservableObject {
    
    @Published private(set) var products: [(userWishlistProduct: UserWishlistProduct, product: Product)] = []
    
    
    func getWishlist() {
        Task {
            let authDataRes = try AuthenticationManager.shared.getAuthenticatedUser()
            let userWishlistProducts = try await UserManager.shared.getAllUserWishlistProducts(userId: authDataRes.uid)
            
            var localArray: [(userWishlistProduct: UserWishlistProduct, product: Product)] = []
            
            for userWishlistedProduct in userWishlistProducts {
                if let product = try? await ProductsManager.shared.getProduct(productId: String(userWishlistedProduct.productId)) {
                    localArray.append((userWishlistedProduct, product))
                }
            }
            self.products = localArray
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

struct WishlistView: View {
    
    @StateObject private var vm = WishlistViewModel()
    
    var body: some View {
        List {
            ForEach(vm.products, id: \.userWishlistProduct.id.self) { item in
                ProductCellView(product: item.product)
                    .contextMenu {
                        Button("Remove from Wishlist") {
                            vm.removeFromWishlist(wishlistProductId: item.userWishlistProduct.id)
                        }
                    }
            }
        }
        .navigationTitle("Wishlist")
        .onAppear {
            vm.getWishlist()
        }
    }
}

#Preview {
    NavigationStack {
        WishlistView()
    }
}
