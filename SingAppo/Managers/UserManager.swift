//
//  UserManager.swift
//  SingAppo
//
//  Created by Zachary on 7/6/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Movie: Codable {
    let id: String
    let title: String
    let isPopular: Bool
}

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let dateCreated: Date?
    let email: String?
    let photoUrl: String?
    let isPremium: Bool?
    let preferences: [String]?
    let favouriteMovie: Movie?
    
    init(auth: AuthDataResModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.dateCreated = Date()
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.isPremium = false
        self.preferences = nil
        self.favouriteMovie = nil
    }
    
    //    init(
    //        userId: String,
    //        isAnonymous: Bool? = nil,
    //        dateCreated: Date? = nil,
    //        email: String? = nil,
    //        photoUrl: String? = nil,
    //        isPremium: Bool? = nil
    //        preferences: [String]? = nil
    //        favouriteMovie: Movie? = nil
    //    ) {
    //        self.userId = userId
    //        self.isAnonymous = isAnonymous
    //        self.dateCreated = dateCreated
    //        self.email = email
    //        self.photoUrl = photoUrl
    //        self.isPremium = isPremium
    //        self.preferences = preferences
    //        self.favouriteMovie = favouriteMovie

    //    }
    
    //    func togglePremiumStatus() -> DBUser {
    //        let currentPremiumStatus = isPremium ?? false
    //        return DBUser(
    //            userId: userId,
    //            isAnonymous: isAnonymous,
    //            dateCreated: dateCreated,
    //            email: email,
    //            photoUrl: photoUrl,
    //            isPremium: !currentPremiumStatus
    //        )
    //    }
    //
    //    mutating func togglePremiumStatus() {
    //        let currentPremiumStatus = isPremium ?? false
    //        isPremium = !currentPremiumStatus
    //    }
    
    
    /// use coding keys to be dynamic to adapt to any key, if decoding/encoding strat doesnt work
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case dateCreated = "email"
        case email = "photo_url"
        case photoUrl = "date_created"
        case isPremium = "is_premium"
        case preferences = "preferences"
        case favouriteMovie = "favourite_movie"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.favouriteMovie, forKey: .favouriteMovie)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.favouriteMovie = try container.decodeIfPresent(Movie.self, forKey: .favouriteMovie)
    }
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
        private let encoder: Firestore.Encoder = {
            let encoder = Firestore.Encoder()
//            encoder.keyEncodingStrategy = .convertToSnakeCase
            return encoder
        }()
    
        private let decoder: Firestore.Decoder = {
            let decoder = Firestore.Decoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    // Without Codable, Store dictionary in Firestore
    /*
     func createNewUser(auth: AuthDataResModel) async throws {
     var userData: [String: Any] = [
     "user_id" : auth.uid,
     "is_anonymous" : auth.isAnonymous,
     "date_created" : Timestamp(),
     ]
     if let email = auth.email {
     userData["email"] = email
     }
     if let photoUrl = auth.photoUrl {
     userData["photo_url"] = photoUrl
     }
     
     try await userDocument(userId: auth.uid).setData(userData, merge: false)
     }
     */
    
    func getUser(userId: String) async throws -> DBUser {
        return try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    /*
     func getUser(userId: String) async throws -> DBUser {
     
     let snapshot = try await userDocument(userId: userId).getDocument()
     
     guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
     throw ErrorMessage.invalidData
     }
     
     let isAnonymous = data["is_anonymous"] as? Bool
     let dateCreated = data["date_created"] as? Date
     let email = data["email"] as? String
     let photoUrl = data["photo_url"] as? String
     
     return DBUser(userId: userId, isAnonymous: isAnonymous, dateCreated: dateCreated, email: email, photoUrl: photoUrl)
     }
     */
    
    //    func updateUserPremiumStatus(user: DBUser) async throws {
    //        try userDocument(userId: user.userId).setData(from: user, merge: true, encoder: encoder)
    //    }
    
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue: isPremium
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addUserPreference(userId: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue: FieldValue.arrayUnion([preference])
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func removeUserPreference(userId: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue: FieldValue.arrayRemove([preference])
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addFavouriteMovie(userId: String, movie: Movie) async throws {
        guard let data = try? encoder.encode(movie) else {
            throw ErrorMessage.errorEncoding
        }
        let dict: [String:Any] = [
            DBUser.CodingKeys.favouriteMovie.rawValue: data
        ]
        try await userDocument(userId: userId).updateData(dict)
    }
    
    func removeFavouriteMovie(userId: String) async throws {
        let data: [String:Any?] = [
            DBUser.CodingKeys.favouriteMovie.rawValue : nil
        ]
        try await userDocument(userId: userId).updateData(data as [AnyHashable : Any])
    }
}
