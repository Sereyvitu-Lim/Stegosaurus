//
//  DefaultImageCollectionViewCell.swift
//  Stegosaurus
//
//  Created by Sereyvitu Lim on 10/15/18.
//  Copyright © 2018 com.SereyvituLim. All rights reserved.
//

import UIKit

protocol DefaultImageSelectionDelegate: class {
    func didSelectDefaultImage(image: UIImage)
}

class DefaultImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var defaultImage: UIImageView!
    weak var delegate: DefaultImageSelectionDelegate?
    
    var image: DefaultImage? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = image {
            defaultImage.image = image.image
        }
    }
    
    @objc func handleImageGesture() {
        //if let image = image {
            delegate?.didSelectDefaultImage(image: defaultImage.image!)
        //}
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleImageGesture))
        defaultImage.addGestureRecognizer(gesture)
        defaultImage.isUserInteractionEnabled = true

    }
    
}
