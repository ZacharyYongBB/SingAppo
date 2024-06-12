//
//  ProductsView.swift
//  SingAppo
//
//  Created by Zachary on 10/6/24.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOptions? = nil
    @Published var selectedCategory: CategoryOption? = nil
    private var lastDocument: DocumentSnapshot? = nil
    @Published var productsCount: Int? = nil
    
    //    func getAllProducts() async throws {
    //        self.products = try await ProductsManager.shared.getAllProducts()
    //    }
    //
    enum FilterOptions: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter:
                return nil
            case .priceHigh:
                return true
            case .priceLow:
                return false
            }
        }
    }
    
    func filterSelected(option: FilterOptions) async throws {
        self.selectedFilter = option
        self.products = []
        self.lastDocument = nil
        self.getProducts()
    }
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case smartphones
        case laptops
        case fragrances
        case furniture
        case beauty
        case groceries
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            return self.rawValue
        }
    }
    
    func categorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        self.products = []
        self.lastDocument = nil
        self.getProducts()
    }
    
    func getProducts() {
        Task {
            let (newProducts, lastDoc) = try await ProductsManager.shared.getAllProducts(priceDesc: selectedFilter?.priceDescending, forCategory: selectedCategory?.categoryKey, count: 5, lastDoc: lastDocument)
            self.products.append(contentsOf: newProducts)
            if let lastDoc {
                self.lastDocument = lastDoc
            }
        }
    }
    
    func getProductsCount() {
        Task {
            self.productsCount = try? await ProductsManager.shared.getAllProductsCount()
        }
    }
    
    func addUserWishlistProduct(productId: Int) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.addUserWishlistProduct(
                userId: authDataResult.uid,
                productId: productId
            )
        }
    }
    
    //    func getProductsByRating() {
    //        Task {
    ////            let newProducts = try await ProductsManager.shared.getProductsByRating(count: 3, lastRating: self.products.last?.rating)
    //            let (newProducts, lastDoc) = try await ProductsManager.shared.getProductsByRating(count: 3, lastDoc: lastDocument)
    //            self.products.append(contentsOf: newProducts)
    //            self.lastDocument = lastDoc
    //        }
    //    }
}

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
