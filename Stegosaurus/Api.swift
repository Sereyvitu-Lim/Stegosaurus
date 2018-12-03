//
//  Api.swift
//  Stegosaurus
//
//  Created by Sereyvitu Lim on 10/27/18.
//  Copyright © 2018 com.SereyvituLim. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class Api {
    
    static func decryptionRequest(url: String, imageData: Data? = nil, parameters: [String : Any], onCompletion: @escaping (Data, String?) -> (Void), onError: @escaping (String) -> Void) {
        
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData {
                multipartFormData.append(data, withName: "image", fileName: "1540496319460.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    let statusCode = response.response?.statusCode
                    if statusCode == 200 {
                        if let stringData = String(data: response.data!, encoding: String.Encoding.utf8) {
                            onCompletion(response.data!, stringData)
                        } else {
                            onCompletion(response.data!, nil)
                        }
                    } else {
                        if let error = response.value as? String {
                            onError(error)
                        }
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                //onError(error)
            }
        }
    }
    
    static func encryptionRequest(url: String, coverImageData: Data, hiddenImageData: Data? = nil, parameters: [String : Any], onCompletion: @escaping (String) -> (Void), onError: @escaping (String) -> Void) {
        
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            multipartFormData.append(coverImageData, withName: "image", fileName: "lolddffsdfs11.png", mimeType: "image/png")
            
            if let data = hiddenImageData {
                multipartFormData.append(data, withName: "content", fileName: "secosdfaadsdfnd11.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    let statusCode = response.response?.statusCode
                    if statusCode == 200 {
                        if let value = response.value as? String {
                            onCompletion(value)
                        }
                    } else {
                        if let error = response.value as? String {
                            onError(error)
                        }
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                //onError(error)
            }
        }
    }
    
}
