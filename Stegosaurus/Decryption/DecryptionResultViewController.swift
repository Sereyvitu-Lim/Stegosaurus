//
//  DecryptionResultViewController.swift
//  Stegosaurus
//
//  Created by Sereyvitu Lim on 10/27/18.
//  Copyright © 2018 com.SereyvituLim. All rights reserved.
//

import UIKit

class DecryptionResultViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!

    var requestedData: Data!
    var requestedString: String?
    
    lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.font = UIFont.systemFont(ofSize: 20)
        
        return textView
    }()
    
    lazy var hiddenImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if requestedString != nil {
            messageTextView.text = requestedString
        } else {
            hiddenImageView.image = UIImage(data: requestedData)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if requestedString != nil {
            createMessageTextViewConstraints()
        } else {
            createImageViewConstraints()
        }
    }
    
    @IBAction func doneButton_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func createMessageTextViewConstraints() {
        view.addSubview(messageTextView)
        
        NSLayoutConstraint.activate([
            messageTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
            messageTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            messageTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            messageTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func createImageViewConstraints() {
        view.addSubview(hiddenImageView)
        
        NSLayoutConstraint.activate([
            hiddenImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
            hiddenImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            hiddenImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            hiddenImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
}
