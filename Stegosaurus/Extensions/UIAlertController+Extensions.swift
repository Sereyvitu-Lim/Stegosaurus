//
//  UIAlertController+Extensions.swift
//  Stegosaurus
//
//  Created by Sereyvitu Lim on 10/27/18.
//  Copyright © 2018 com.SereyvituLim. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func createActionView(title: String, message: String, actionText: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: actionText, style: .default, handler: nil)
        alert.addAction(retryAction)
        
        return alert
    }
    
}
