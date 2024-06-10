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
    @Published var selectedFilter: FilterOptions? = nil
    @Published var selectedCategory: CategoryOption? = nil
    
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
        self.getProducts()
        //        switch option {
        //        case .noFilter:
        //            self.products = try await ProductsManager.shared.getAllProducts()
        //        case .priceHigh:
        //            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(desc: true)
        //        case .priceLow:
        //            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(desc: false)
        //        }
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
        self.getProducts()
        //        switch option {
        //        case .noCategory:
        //            self.products = try await ProductsManager.shared.getAllProducts()
        //        case .smartphones, .laptops, .fragrances, .furniture, .beauty, .groceries:
        //            self.products = try await ProductsManager.shared.getAllProductsForCatefory(category: option.rawValue)
        //        }
        
        
    }
    
    func getProducts() {
        Task {
            self.products = try await ProductsManager.shared.getAllProducts(priceDesc: selectedFilter?.priceDescending, forCategory: selectedCategory?.categoryKey)
        }
        
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
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
