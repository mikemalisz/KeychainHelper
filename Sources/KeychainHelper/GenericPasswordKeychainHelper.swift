//
//  GenericPasswordKeychainHelper.swift
//  
//
//  Created by Mike Maliszewski on 12/26/20.
//

import Foundation

/// Creates a KeychainHelper using `kSecClassGenericPassword` for the `kSecClass` keychain attribute
class GenericPasswordKeychainHelper: KeychainHelper {
    /// the keychain item service identifier that this object acts upon
    let serviceAttribute: String
    
    /// Initializes a helper for the given Generic Password service
    /// - Parameter serviceAttribute: the keychain item service identifier `kSecAttrService`
    init(serviceAttribute: String) {
        self.serviceAttribute = serviceAttribute
        
        super.init(keychainAttributes: [
            String(kSecClass): kSecClassGenericPassword,
            String(kSecAttrService): serviceAttribute
        ])
    }
}
