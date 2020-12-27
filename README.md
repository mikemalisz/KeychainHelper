# A simple wrapper for working with Apple's Keychain API 🔑 

[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

This package currently provides functionality for getting, setting, and deleting values from the keychain. 

## Install

This package is currently only installable via Swift Package Manager.

#### Swift Package Manager

1. In the Xcode menu bar, go to File > Swift Packages > Add Package Dependency...
2. Enter https://github.com/mikemalisz/KeychainHelper into the package URL prompt

## Usage

First, add `import KeychainHelper` at the top of your file.

#### Initialization

Next, you can initialize a new `KeychainHelper` object by providing the Keychain attributes you'd like to work with. These attributes represent information about the type data you'd like to store, similar to key values when using the `UserDefaults` API. More information about Keychain Items can be found here: https://developer.apple.com/documentation/security/keychain_services/keychain_items

Example of initializing a `KeychainHelper` object for a generic password:

```Swift
let attributes: [String: Any] = [
    String(kSecClass): kSecClassGenericPassword, 
    String(kSecAttrService): "authentication"
]
let keychainHelper = KeychainHelper(keychainAttributes: attributes)
```
Now, you can use this object to read, set, or delete values for the given attributes

#### Setting values

```Swift
do {
    try keychainHelper.setValue("password1234")
} catch {
    print(error)
}
```

This method sets the given value for the attributes given during initialization. It can throw if an unexpected error occurs in the Keychain API.

#### Reading a stored value

```Swift
do {
    let decryptedValue = try keychainHelper.getValue()
    guard let decryptedValue = try keychainHelper.getValue() else { 
        return
    }
    // use decrypted value
} catch {
    print(error)
}
```
#### Deleting a stored value
```Swift
do {
    try keychainHelper.deleteValue()
} catch {
    print(error)
}
```
This method returns normally if either the value was successfully deleted or if the value was not found (unset). Throws if an unexpected error occurs in the Keychain API.

## Subclasses

Subclasses of KeychainHelper might be a good idea for reducing the setup required. `GenericPasswordKeychainHelper` is an example of a simple subclass that initializes KeychainHelper specifying attributes for a Generic Password. 

Example usage might consist of:

```Swift
let passwordHelper = GenericPasswordKeychainHelper(serviceAttribute: "authentication")
try? passwordHelper.setValue("my-password")
```

We can then read the value of the password later on

```Swift
let passwordHelper = GenericPasswordKeychainHelper(serviceAttribute: "authentication")
let myPassword = try? passwordHelper.getValue()
print(myPassword) // "my-password"
```

## Inspiration
Inspired by this article on https://www.raywenderlich.com/9240-keychain-services-api-tutorial-for-passwords-in-swift
