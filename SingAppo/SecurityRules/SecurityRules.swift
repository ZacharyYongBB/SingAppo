//
//  SecurityRules.swift
//  SingAppo
//
//  Created by Zachary on 17/6/24.
//

import Foundation

// https://console.firebase.google.com/project/singappo-7b8ba/firestore/databases/-default-/rules

/*
 rules_version = '2';

 service cloud.firestore {
   match /databases/{database}/documents {
     match /users/{userId} {
       allow read: if request.auth != null;
       allow write: if request.auth != null && request.auth.uid == userId;
       // allow write: if resource.data.user_isPremium == false
       // allow write: if request.resource.data.custom_key == "123"
       // allow write: if isPublic();
     }
     
     match /users/{userId}/wishlist_products/{userWishlistProductID} {
             allow read: if request.auth != null;
       allow write: if request.auth != null && request.auth.uid == userId;
         }
     
     match /products/{productId} {
         // allow read, write: if request.auth != null
       // allow create: if request.auth != null;
       // allow read: if request.auth != null && isAdmin(request.auth.uid)
       allow read: if request.auth != null
       allow create: if request.auth != null && isAdmin(request.auth.uid)
       allow update: if request.auth != null && isAdmin(request.auth.uid)
       allow delete: if false
     }
     
     function isAdmin(userId) {
         // let adminIds = [
         // "UGQayYernYdzUGEIEMxoxTFgsT33",
         // "123123"
         // ];
         // return userId in adminIds;
       return exists(/databases/$(database)/documents/admins/$(userId));
     }
     
     function isPublic() {
         return resource.data.visibility == "public";
     }
     
   }
 }

 // read
 // get - single document read
 // list - queries and collection read requests
 //
 // write
 // create
 // update
 // delete
 */
