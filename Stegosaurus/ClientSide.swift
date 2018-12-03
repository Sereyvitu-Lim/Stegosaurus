//
//  ClientSide.swift
//  Stegosaurus
//
//  Created by Sereyvitu Lim on 10/31/18.
//  Copyright © 2018 com.SereyvituLim. All rights reserved.
//

import UIKit
import CommonCrypto
import CryptoSwift

class ClientSide {
    
    static func clientEncryption(input: String, password: String) -> Data {
        let keys = generateKeys(password: password)
        
        let iv: Array<UInt8> = AES.randomIV(AES.blockSize)
        
        let extractedKey = stringToBytes(keys[1])!
        
        let extractedInput: Array<UInt8> = Array(input.utf8)
        
        let encrypted = try! AES(key: extractedKey, blockMode: CBC(iv: iv), padding: .zeroPadding).encrypt(extractedInput)
        
        let ivBase64 = iv.data //iv.toBase64()
        let encBase64 = encrypted.data //encrypted.toBase64()
        let concat = ivBase64 + encBase64

        return concat
    }
    
    static func clientEncryptionImage(input: Data, password: String) -> Data {
        let keys = generateKeys(password: password)
        
        let iv: Array<UInt8> = AES.randomIV(AES.blockSize)
        let extractedKey = stringToBytes(keys[1])!
        
        //let str = input.bytes
        let extractedInput: Array<UInt8> = input.bytes
        
        let encrypted = try! AES(key: extractedKey, blockMode: CBC(iv: iv), padding: .zeroPadding).encrypt(extractedInput)
        
        let ivBase64 = iv.data //iv.toBase64()
        let encBase64 = encrypted.data //encrypted.toBase64()
        let concat = ivBase64 + encBase64
        
        return concat
    }
    
    static func clientDecryption(content: Data, password: String, onCompleted: @escaping (String) -> (Void), onError: @escaping (String) -> (Void)) {
        let keys = generateKeys(password: password)
        let extractedKey = stringToBytes(keys[1])!
        
        let bytes = content.bytes
        
        let iv: Array<UInt8> = Array(bytes[0..<16])
        let encryptedContent: Array<UInt8> = Array(bytes[16..<bytes.count])
        
        do {
            let decrypted = try AES(key: extractedKey, blockMode: CBC(iv: iv), padding: .zeroPadding).decrypt(encryptedContent)
            let str = String(bytes: decrypted, encoding: String.Encoding.utf8)
            if let str = str {
                onCompleted(str)
            } else {
                onError("Key does not match")
            }
        } catch {
            NSLog("Nothing")
        }
    }
    
    static func clientDecryptionImage(content: Data, password: String, onCompleted: @escaping (Data)->(Void), onError: @escaping (String)->(Void)) {
        let keys = generateKeys(password: password)
        let extractedKey = stringToBytes(keys[1])!
        
        let bytes = content.bytes
        
        let iv: Array<UInt8> = Array(bytes[0..<16]) //str!.prefix(24).description
        let encryptedContent: Array<UInt8> = Array(bytes[16..<bytes.count]) //str!.substring(from: 24)
        
        //let decryptIV: Array<UInt8> = stringToBytes(iv)! //base64ToByteArray(base64String: iv)!
        //let decryptEnc: Array<UInt8> = stringToBytes(encryptedContent)! //base64ToByteArray(base64String: encryptedContent)!
        
        do {
            let decrypted = try AES(key: extractedKey, blockMode: CBC(iv: iv), padding: .zeroPadding).decrypt(encryptedContent)
            let data: Data? = Data(bytes: decrypted)
            if let data = data {
                onCompleted(data)
            } else {
                onError("Key does not match")
            }
        } catch {
            NSLog("Nothing")
        }
    }
    
    private static func generateKeys(password: String) -> [String] {
        let hashedPassword = password.sha256()
        
        let splitedPassword = ClientSide.splitStringInHalf(text: hashedPassword)
        let firstHalf = password + splitedPassword[0]
        let secondHalf = password + splitedPassword[1]
        
        let serverKey = generateServerKey(password: firstHalf)
        let clientKey = generateClientKey(password: secondHalf)
        
        return [serverKey, clientKey]
    }
    
//    static func base64ToByteArray(base64String: String) -> [UInt8]? {
//        if let nsdata = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
//            var bytes = [UInt8](repeating: 0, count: nsdata.length)
//            nsdata.getBytes(&bytes)
//            return bytes
//        }
//        return nil // Invalid input
//    }
    
    private static func generateClientKey(password: String) -> String {
        return password.sha256()
    }
    
    private static func generateServerKey(password: String) -> String {
        return password.sha256()
    }
    
    private static func splitStringInHalf(text: String) -> [String.SubSequence] {
        var strArray = [String.SubSequence]()
        
        let index = text.index(text.startIndex, offsetBy: 32)
        let last = text.index(text.endIndex, offsetBy: 0)
        let firstHash = text[..<index]
        let secondHash = text[index..<last]
        
        strArray.append(firstHash)
        strArray.append(secondHash)
        
        return strArray
    }
    
//    static func sha256Hash(_ string: String) -> Data? {
//        let len = Int(CC_SHA256_DIGEST_LENGTH)
//        let data = string.data(using:.utf8)!
//        var hash = Data(count:len)
//        
//        let _ = hash.withUnsafeMutableBytes {hashBytes in
//            data.withUnsafeBytes {dataBytes in
//                CC_SHA256(dataBytes, CC_LONG(data.count), hashBytes)
//            }
//        }
//        return hash
//    }
    
    static func stringToBytes(_ string: String) -> [UInt8]? {
        let length = string.characters.count
        if length & 1 != 0 {
            return nil
        }
        var bytes = [UInt8]()
        bytes.reserveCapacity(length/2)
        var index = string.startIndex
        for _ in 0..<length/2 {
            let nextIndex = string.index(index, offsetBy: 2)
            if let b = UInt8(string[index..<nextIndex], radix: 16) {
                bytes.append(b)
            } else {
                return nil
            }
            index = nextIndex
        }
        return bytes
    }
    
}

extension String {
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    
}
