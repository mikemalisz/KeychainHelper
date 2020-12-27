//
//  KeychainHelperError.swift
//  
//
//  Created by Mike Maliszewski on 12/26/20.
//

import Foundation

enum KeychainHelperError: Error {
  case stringToDataConversionError
  case dataToStringConversionError
  case unhandledError(message: String)
}

extension KeychainHelperError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .stringToDataConversionError:
      return NSLocalizedString("String to Data conversion error", comment: "")
    case .dataToStringConversionError:
      return NSLocalizedString("Data to String conversion error", comment: "")
    case .unhandledError(let message):
      return NSLocalizedString(message, comment: "")
    }
  }
}
