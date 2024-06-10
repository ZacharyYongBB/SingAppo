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
        try await productDocument(productId: productId).getDocument(as: Product.self)
    }
    
    func getAllProducts() async throws -> [Product] {
        try await productsCollection.getDocuments(as: Product.self)
    }
}

extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.map { doc in
            try doc.data(as: T.self)
        }
        
    }
    
}
