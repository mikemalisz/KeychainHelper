
import XCTest
@testable import KeychainHelper

final class GenericPasswordKeychainHelperTests: XCTestCase {
    
    private var helper: GenericPasswordKeychainHelper!
    
    override func setUp() {
        super.setUp()
        
        let serviceAttribute = "myPassword"
        helper = GenericPasswordKeychainHelper(serviceAttribute: serviceAttribute)
    }
    
    override func tearDown() {
        super.tearDown()
        
        try? helper.deleteValue()
    }
    
    func testSetValueOnce() {
        let testValue = "first"
        do {
            try helper.setValue(testValue)
            
            let returnedValue = try helper.getValue()
            
            XCTAssert(testValue == returnedValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    /// Test setting the value twice to ensure both methods of setting work (add value then update value in keychain store)
    func testSetValueTwice() {
        let firstTest = "first"
        let secondTest = "second"
        do {
            try helper.setValue(firstTest)
            try helper.setValue(secondTest)
            
            let returnedValue = try helper.getValue()
            
            XCTAssert(secondTest == returnedValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDeleteValue() {
        let firstTest = "first"
        do {
            try helper.setValue(firstTest)
            try helper.deleteValue()
            
            let returnedValue = try helper.getValue()
            
            XCTAssert(returnedValue == nil)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

