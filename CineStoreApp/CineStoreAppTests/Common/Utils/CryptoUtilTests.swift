//
//  CryptoUtilTests.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 27/08/24.
//

import XCTest
@testable import CineStoreApp
import CommonCrypto

class CryptoUtilTests: XCTestCase {

    func testEncryptionAndDecryption() {
        // Input data
        let message = "Hello world"
        let messageData = Array(message.utf8)
        let keyData = Array("MY SECRET KEY 123".utf8)
        let ivData = Array("ui09ji884uh88984".utf8)
        
        // Perform encryption
        let encryptedString = CryptoUtil.encrypt(data: messageData, keyData: keyData, ivData: ivData)
        XCTAssertNotNil(encryptedString, "Encryption failed: encryptedString is nil")
        
        // Perform decryption
        let decryptedMessage = CryptoUtil.decrypt(base64EncodedString: encryptedString!, keyData: keyData, ivData: ivData)
        XCTAssertNotNil(decryptedMessage, "Decryption failed: decryptedMessage is nil")
        
        // Verify that the decrypted data matches the original message
        XCTAssertEqual(decryptedMessage, message, "Decrypted message does not match the original")
    }
    
    func testBase64Decryption() {
        // Known encrypted base64 string (for testing purposes, replace with a valid string)
        let keyData = Array("MY SECRET KEY 123".utf8)
        let ivData = Array("ui09ji884uh88984".utf8)
        
        let base64EncryptedString = "gsrpgZfNLMh0jfpxDVybOQ=="
        
        // Perform decryption
        let decryptedMessage = CryptoUtil.decrypt(base64EncodedString: base64EncryptedString, keyData: keyData, ivData: ivData)
        XCTAssertNotNil(decryptedMessage, "Decryption failed: decryptedMessage is nil")
    }
}
