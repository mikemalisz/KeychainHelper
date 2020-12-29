//
//  KeychainHelper.swift
//
//
//  Created by Mike Maliszewski on 12/26/20.
//

import Foundation

open class KeychainHelper {
    
    // MARK: - Properties & Initialization
    
    /// the attributes this helper uses to interact with the keychain
    public let keychainAttributes: [String: Any]
    
    public init(keychainAttributes: [String: Any]) {
        self.keychainAttributes = keychainAttributes
    }
    
    // MARK: - API
    
    /// Sets the given value for the Keychain Item using the keychainAttributes property
    /// - Parameter value: the new value to set
    /// - Throws: KeychainHelperError if the value was not set successfully
    open func setValue(_ value: Data) throws {
        // check if keychain already contains a value for the
        // attributes of this object and set the value accordingly
        var newQuery = keychainAttributes
        var result = SecItemCopyMatching(newQuery as CFDictionary, nil)
        
        switch result {
        case errSecSuccess:
            // keychain item exists, update the existing item with the new value
            var newAttributes = [String: Any]()
            newAttributes[String(kSecValueData)] = value
            
            result = SecItemUpdate(newQuery as CFDictionary, newAttributes as CFDictionary)
            if result != errSecSuccess {
                throw generateError(with: result)
            }
        case errSecItemNotFound:
            // item doesn't exist, add a new keychain item with this value
            newQuery[String(kSecValueData)] = value
            result = SecItemAdd(newQuery as CFDictionary, nil)
            
            if result != errSecSuccess {
                throw generateError(with: result)
            }
        
        default:
            // unhandled OSStatus code, throw error
            throw generateError(with: result)
        }
    }
    
    /// Retrieves the Keychain Item value using the keychainAttributes property
    /// - Throws: KeychainHelperError if the value couldn't be decoded
    /// - Returns: `Data` if a value was found, or `nil` if no value exists
    open func getValue() throws -> Data? {
        // create a query that specifies which data we want returned
        var newQuery = keychainAttributes
        newQuery[String(kSecMatchLimit)] = kSecMatchLimitOne
        newQuery[String(kSecReturnAttributes)] = kCFBooleanTrue
        newQuery[String(kSecReturnData)] = kCFBooleanTrue
        
        // retrieve data using the query and attempt to store
        // it in queryResult
        var queryResult: AnyObject?
        let result = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(newQuery as CFDictionary, $0)
        }
        
        // handle the result of the query
        switch result {
        case errSecSuccess:
            guard
                let keychainItem = queryResult as? [String: Any],
                let valueData = keychainItem[String(kSecValueData)] as? Data
            else {
                throw KeychainHelperError.dataToStringConversionError
            }
            
        return valueData
        case errSecItemNotFound:
            return nil
        default:
            throw generateError(with: result)
        }
    }
    
    /// Attempts to delete the Keychain Item associated with the keychainAttributes property
    /// - Throws: KeychainHelperError if an error occurs
    open func deleteValue() throws {
        let result = SecItemDelete(keychainAttributes as CFDictionary)
        
        guard result == errSecSuccess || result == errSecItemNotFound else {
            throw generateError(with: result)
        }
    }
    
    // MARK: - Error Handling
    
    private func generateError(with status: OSStatus) -> KeychainHelperError {
        let message = SecCopyErrorMessageString(status, nil) as String? ?? Constants.unknownErrorMessage
        return KeychainHelperError.unhandledError(message: message)
    }
    
    private struct Constants {
        static let unknownErrorMessage = "An unknown error has occurred"
    }
}
