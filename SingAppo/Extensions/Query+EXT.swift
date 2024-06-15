//
//  Query+EXT.swift
//  SingAppo
//
//  Created by Zachary on 15/6/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

extension Query {
    
    //    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
    //        let snapshot = try await self.getDocuments()
    //
    //        return try snapshot.documents.map { doc in
    //            try doc.data(as: T.self)
    //        }
    //    }
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        try await getDocumentsWithSnapshot(as: type).products
    }
    
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (products: [T], lastDoc: DocumentSnapshot?) where T: Decodable {
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map { doc in
            try doc.data(as: T.self)
        }
        
        return (products, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else {
            return self
        }
        return self
            .start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        return Int(truncating: try await self.count.getAggregation(source: .server).count)
    }
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error> , ListenerRegistration) where T : Decodable {
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            let products: [T] = documents.compactMap { documentSnapshot in
                return try? documentSnapshot.data(as: T.self)
            }
            publisher.send(products)
        }
        
        return (publisher.eraseToAnyPublisher(), listener)
    }
    
}


