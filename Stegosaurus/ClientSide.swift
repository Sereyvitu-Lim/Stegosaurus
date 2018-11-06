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
        let extractedKey = Array(sha256Hash(keys[1])!)
        let extractedInput: Array<UInt8> = Array(input.utf8)
        
        let encrypted = try! AES(key: extractedKey, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(extractedInput)
        let content = iv + encrypted
        
        return Data(bytes: content)
    }
    
    static func clientDecryption(data: Data, password: String) {
        //let keys = generateKeys(password: password)
        
        //var byteArray: Array<UInt8> = Array(data)
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
    
    static func sha256Hash(_ string: String) -> Data? {
        let len = Int(CC_SHA256_DIGEST_LENGTH)
        let data = string.data(using:.utf8)!
        var hash = Data(count:len)
        
        let _ = hash.withUnsafeMutableBytes {hashBytes in
            data.withUnsafeBytes {dataBytes in
                CC_SHA256(dataBytes, CC_LONG(data.count), hashBytes)
            }
        }
        return hash
    }
    
}
