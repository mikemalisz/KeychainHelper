
import XCTest
@testable import KeychainHelper

final class KeychainHelperTests: XCTestCase {
    
    private var helper: KeychainHelper!
    
    override func setUp() {
        super.setUp()
        
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "myPassword"
        ]
        helper = KeychainHelper(keychainAttributes: attributes)
    }
    
    override func tearDown() {
        super.tearDown()
        
        try? helper.deleteValue()
    }
    
    func testSetValueOnce() {
        let testValue = "first"
        do {
            try helper.setValue(testValue.data(using: .utf8)!)
            
            let returnedValue = try helper.getValue()!
            
            XCTAssert(testValue == String(data: returnedValue, encoding: .utf8))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    /// Test setting the value twice to ensure both methods of setting work (add value then update value in keychain store)
    func testSetValueTwice() {
        let firstTest = "first"
        let secondTest = "second"
        do {
            try helper.setValue(firstTest.data(using: .utf8)!)
            try helper.setValue(secondTest.data(using: .utf8)!)
            
            let returnedValue = try helper.getValue()!
            
            XCTAssert(secondTest == String(data: returnedValue, encoding: .utf8))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDeleteValue() {
        let firstTest = "first"
        do {
            try helper.setValue(firstTest.data(using: .utf8)!)
            try helper.deleteValue()
            
            let returnedValue = try helper.getValue()
            
            XCTAssert(returnedValue == nil)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

