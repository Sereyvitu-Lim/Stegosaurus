//
//  EncryptionResultViewController.swift
//  Stegosaurus
//
//  Created by Sereyvitu Lim on 10/27/18.
//  Copyright © 2018 com.SereyvituLim. All rights reserved.
//

import UIKit
import SDWebImage

class EncryptionResultViewController: UIViewController {
    
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var linkTextField: UITextField!
    
    var link: String!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleImageAndLink()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func handleImageAndLink() {
        displayImageView.sd_setImage(with: URL(string: link), placeholderImage: nil)
        linkTextField.text = link
    }
    
    @IBAction func doneButton_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
