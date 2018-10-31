//
//  DefaultImage.swift
//  Stegosaurus
//
//  Created by Sereyvitu Lim on 10/15/18.
//  Copyright © 2018 com.SereyvituLim. All rights reserved.
//

import UIKit

struct DefaultImage {
    
    let image: UIImage!
    
    static func createDefaultImageArray() -> [DefaultImage] {
        var temp = [DefaultImage]()
        
        let i1 = DefaultImage(image: UIImage(named: "mario1"))
        let i2 = DefaultImage(image: UIImage(named: "darksouls1"))
        let i3 = DefaultImage(image: UIImage(named: "splatoon1"))
        let i4 = DefaultImage(image: UIImage(named: "rocketleague1"))
        let i5 = DefaultImage(image: UIImage(named: "zelda1"))
        let i6 = DefaultImage(image: UIImage(named: "stardew1"))
        
        temp.append(i1)
        temp.append(i2)
        temp.append(i3)
        temp.append(i4)
        temp.append(i5)
        temp.append(i6)
        
        return temp
    }
    
}
