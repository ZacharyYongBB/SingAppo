//
//  AuthDataResModel.swift
//  SingAppo
//
//  Created by Zachary on 4/6/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResModel {
    
    let uid: String
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
    
}
