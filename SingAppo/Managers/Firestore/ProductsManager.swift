//
//  ProductsManager.swift
//  SingAppo
//
//  Created by Zachary on 10/6/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/*
 func downloadProductsAndUploadToFirebase() {
 guard let url = URL(string: "https://dummyjson.com/products") else { return }
 Task {
 do {
 let (data, response) = try await URLSession.shared.data(from: url)
 let products = try JSONDecoder().decode(ProductArray.self, from: data)
 let productArray = products.products
 
 for product in productArray {
 try? await ProductsManager.shared.uplaodProduct(product: product)
 }
 print("succ")
 } catch {
 print("error")
 print(error)
 }
 }
 }
 */

final class ProductsManager {
    
    static let shared = ProductsManager()
    private init() { }
    
    private let productsCollection = Firestore.firestore().collection("products")
    
    private func productDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    func uplaodProduct(product: Product) async throws {
        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
    func getProduct(productId: String) async throws -> Product {
        try await productDocument(productId: productId)
            .getDocument(as: Product.self)
    }
    //
    //    private func getAllProducts() async throws -> [Product] {
    //        try await productsCollection
    //            .getDocuments(as: Product.self)
    //    }
    //
    //    private func getAllProductsSortedByPrice(desc: Bool) async throws -> [Product] {
    //        try await productsCollection
    //            .order(by: Product.CodingKeys.price.rawValue, descending: desc)
    //            .getDocuments(as: Product.self)
    //    }
    //
    //    private func getAllProductsForCategory(category: String ) async throws -> [Product] {
    //        try await productsCollection
    //            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    //            .getDocuments(as: Product.self)
    //    }
    //
    //    private func getAllProductsByPriceAndCategory(desc: Bool, category: String) async throws -> [Product] {
    //        try await productsCollection
    //            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    //            .order(by: Product.CodingKeys.price.rawValue, descending: desc)
    //            .getDocuments(as: Product.self)
    //    }
    
    
    private func getAllProductsQuery() -> Query {
        productsCollection
    }
    
    private func getAllProductsSortedByPriceQuery(desc: Bool) -> Query {
        productsCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: desc)
    }
    
    private func getAllProductsForCategoryQuery(category: String ) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    }
    
    private func getAllProductsByPriceAndCategoryQuery(desc: Bool, category: String) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: desc)
    }
    
    func getAllProducts(priceDesc desc: Bool?,forCategory category: String?, count: Int, lastDoc: DocumentSnapshot?) async throws -> (products: [Product], lastDoc: DocumentSnapshot?) {
        
        var query: Query = getAllProductsQuery()
        
        if let desc, let category {
            query = getAllProductsByPriceAndCategoryQuery(desc: desc, category: category)
        } else if let desc {
            query = getAllProductsSortedByPriceQuery(desc: desc)
        } else if let category {
            query = getAllProductsForCategoryQuery(category: category)
        }
        
        return try await query
            .limit(to: count)
            .startOptionally(afterDocument: lastDoc)
            .getDocumentsWithSnapshot(as: Product.self)
        
      
    }
    
    func getProductsByRating(count: Int, lastRating: Double?) async throws -> [Product] {
        try await productsCollection
            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
            .limit(to: count)
            .start(after: [lastRating ?? 999999999])
            .getDocuments(as: Product.self)
    }
    
    func getProductsByRating(count: Int, lastDoc: DocumentSnapshot?) async throws -> (products: [Product], lastDoc: DocumentSnapshot?) {
        guard let lastDoc else {
            return try await productsCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .getDocumentsWithSnapshot(as: Product.self)
        }
        return try await productsCollection
            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
            .limit(to: count)
            .start(afterDocument: lastDoc)
            .getDocumentsWithSnapshot(as: Product.self)
    }
    
    func getAllProductsCount() async throws -> Int {
        try await productsCollection.aggregateCount()
    }
    
    
}

