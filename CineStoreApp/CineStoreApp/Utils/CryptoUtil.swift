//
//  CryptoUtil.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 27/08/24.
//  Inspired on: https://forums.developer.apple.com/forums/thread/707111

import Foundation
import CommonCrypto

struct CryptoUtil {
    
    static func encrypt(data: [UInt8], keyData: [UInt8], ivData: [UInt8] = Array("ui09ji884uh88984".utf8)) -> String? {
        guard let encryptedData = cyrptoOperation(data: data, keyData: keyData, ivData: ivData, operation: kCCEncrypt) else {
            return nil
        }
        // Convert the encrypted byte array to a base64-encoded string
        let encryptedDataBase64 = Data(encryptedData).base64EncodedString()
        return encryptedDataBase64
    }
    
    static func decrypt(base64EncodedString: String, keyData: [UInt8], ivData: [UInt8] = Array("ui09ji884uh88984".utf8)) -> String? {
        guard let encryptedData = Data(base64Encoded: base64EncodedString) else {
            return nil
        }
        let decryptedData = cyrptoOperation(data: Array(encryptedData), keyData: keyData, ivData: ivData, operation: kCCDecrypt)
        return decryptedData.flatMap { String(bytes: $0, encoding: .utf8) }
    }

    static func cyrptoOperation(data: [UInt8], keyData: [UInt8], ivData: [UInt8], operation: Int) -> [UInt8]? {
        let cryptLength = size_t(data.count + kCCBlockSizeAES128)
        var cryptData = [UInt8](repeating: 0, count: cryptLength)

        let keyLength = size_t(kCCKeySizeAES128)
        let algorithm: CCAlgorithm = UInt32(kCCAlgorithmAES128)
        let options: CCOptions = UInt32(kCCOptionPKCS7Padding)

        var numBytesEncrypted: size_t = 0

        let cryptStatus = CCCrypt(CCOperation(operation),
                                  algorithm,
                                  options,
                                  keyData,
                                  keyLength,
                                  ivData,
                                  data,
                                  data.count,
                                  &cryptData,
                                  cryptLength,
                                  &numBytesEncrypted)

        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
        } else {
            print("Error: \(cryptStatus)")
            return nil
        }

        return cryptData
    }
}
