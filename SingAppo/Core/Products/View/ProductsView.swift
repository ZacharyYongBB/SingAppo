//
//  ProductsView.swift
//  SingAppo
//
//  Created by Zachary on 10/6/24.
//

import SwiftUI
import FirebaseFirestore


struct ProductsView: View {
    
    @StateObject private var vm = ProductsViewModel()
    
    var body: some View {
        List {
            Text("Total Number of products: " + String(vm.productsCount ?? 0))
                .font(.headline)
            //            Button("Fetch more") {
            //                vm.getProductsByRating()
            //            }
            
            ForEach(vm.products) { product in
                ZStack(alignment: .topTrailing) {
                    ProductCellView(product: product)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    Image(systemName: "star")
                        .padding(10)
                        .onTapGesture {
                            vm.addUserWishlistProduct(productId: product.id)
                        }
                }
                
                if product == vm.products.last {
                    ProgressView()
                        .onAppear {
                            print("fethcing more data")
                            vm.getProducts()
                        }
                }
            }
        }
        .navigationTitle("Products")
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Menu("Filter: \(vm.selectedFilter?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.FilterOptions.allCases, id: \.self) { options in
                        Button(options.rawValue) {
                            Task {
                                try? await vm.filterSelected(option: options)
                            }
                        }
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Category: \(vm.selectedCategory?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self) { options in
                        Button(options.rawValue) {
                            Task {
                                try? await vm.categorySelected(option: options)
                            }
                        }
                    }
                }
            }
        })
        .onAppear {
            Task {
                vm.getProducts()
                vm.getProductsCount()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
