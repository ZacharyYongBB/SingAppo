//
//  WishlistView.swift
//  SingAppo
//
//  Created by Zachary on 12/6/24.
//

import SwiftUI

@MainActor
final class WishlistViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []

    
    func getWishlist() {
        
    }
    
}

struct WishlistView: View {
    
    @StateObject private var vm = WishlistViewModel()
    
    var body: some View {
        List {
            ForEach(vm.products) { product in
                ProductCellView(product: product)
                    .contextMenu {
                        Button("Add to Wishlist") {
                            
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
