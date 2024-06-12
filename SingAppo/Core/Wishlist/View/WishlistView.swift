//
//  WishlistView.swift
//  SingAppo
//
//  Created by Zachary on 12/6/24.
//

import SwiftUI


struct WishlistView: View {
    
    @StateObject private var vm = WishlistViewModel()
    
    var body: some View {
        List {
            ForEach(vm.userWishlistProducts, id: \.id.self) { item in
                ProductCellViewBuilder(productId: String(item.productId))
                    .contextMenu {
                        Button("Remove from Wishlist") {
                            vm.removeFromWishlist(wishlistProductId: item.id)
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
