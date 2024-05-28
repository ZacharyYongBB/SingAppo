//
//  KeychainManager.swift
//  SingAppo
//
//  Created by Zachary on 28/5/24.
//

import SwiftUI
import KeychainSwift

final class KeychainManager {
    
    private let keychain: KeychainSwift
    
    init() {
        let kc = KeychainSwift()
        kc.synchronizable = true
        self.keychain = kc
    }
    
    func set(_ value: String, key: String) {
        keychain.set(value, forKey: key)
    }
    
    func get(key: String) -> String? {
        keychain.get(key)
    }
    
}

@propertyWrapper
struct KeychainStorage: DynamicProperty {
    @State private var newValue: String
    let key: String
    let keychain: KeychainManager
    
    var wrappedValue: String {
        get {
            newValue
        }
        nonmutating set {
            save(newValue: newValue)
        }
    }
    
    var projectedValue: Binding<String> {
        Binding(get: {
            wrappedValue
        }, set: { newValue in
            wrappedValue = newValue
        })
    }
    
    init(wrappedValue: String, _ key: String) {
        self.key = key
        let keychain = KeychainManager()
        
        self.keychain = keychain
        newValue = keychain.get(key: key) ?? ""
        print("SUCCESS READ")
    }
    
    func save(newValue: String) {
        keychain.set(newValue, key: key)
        self.newValue = newValue
        print("SUCCESS SAVED")
    }
}
