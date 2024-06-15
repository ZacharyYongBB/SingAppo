//
//  ProductsViewModel.swift
//  SingAppo
//
//  Created by Zachary on 15/6/24.
//

import Foundation
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
