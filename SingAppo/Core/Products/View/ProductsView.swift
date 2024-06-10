//
//  ProductsView.swift
//  SingAppo
//
//  Created by Zachary on 10/6/24.
//

import SwiftUI

@MainActor
final class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    
    func getAllProducts() async throws {
        self.products = try await ProductsManager.shared.getAllProducts()
    }
    
}

struct ProductsView: View {
    
    @StateObject private var vm = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(vm.products) { product in
                ProductCellView(product: product)
            }
        }
        .navigationTitle("Products")
        .onAppear {
            Task {
                try? await vm.getAllProducts()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
