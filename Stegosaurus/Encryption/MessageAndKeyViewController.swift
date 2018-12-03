//
//  MessageAndKeyViewController.swift
//  Stegosaurus
//
//  Created by Sereyvitu Lim on 10/15/18.
//  Copyright © 2018 com.SereyvituLim. All rights reserved.
//

import UIKit
import ProgressHUD

class MessageAndKeyViewController: UIViewController {
    
    @IBOutlet weak var encryptButton: UIButton!
    @IBOutlet weak var hiddenMessageTextView: UITextView!
    @IBOutlet weak var keyTextField: UITextField!
    
    var selectedImage: UIImage!
    
    var insertedImageLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenMessageTextView.layer.borderColor = UIColor.gray.cgColor
        hiddenMessageTextView.layer.borderWidth = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func encryptButton_TouchUpInside(_ sender: Any) {
        /// ** No Client Side Encryption ** ///
        
//        ProgressHUD.show("Loading")
//        let url = Config.baseUrl + "/insert"
//        let params = ["key": keyTextField.text!]
//        let textData = hiddenMessageTextView.text.data(using: String.Encoding.utf8)
//
//        Api.encryptionRequest(url: url, coverImageData: selectedImage.pngData()!, hiddenImageData: textData, parameters: params, onCompletion: { (link) -> (Void) in
//            ProgressHUD.dismiss()
//            self.insertedImageLink = link
//            self.performSegue(withIdentifier: "MessageToResult_Segue", sender: link)
//        }) { (error) in
//            ProgressHUD.dismiss()
//            let alert = UIAlertController.createActionView(title: "Error", message: error, actionText: "Retry")
//            self.present(alert, animated: true, completion: nil)
//        }
        
        if Reachability.isConnectedToNetwork() {
            guard let key = keyTextField.text, let message = hiddenMessageTextView.text else { return }
            
            if key.isEmpty && message.isEmpty {
                let alert = UIAlertController.createActionView(title: "Error", message: "Please Provide Both Inputs", actionText: "Retry")
                self.present(alert, animated: true, completion: nil)
            } else if key.isEmpty {
                let alert = UIAlertController.createActionView(title: "Error", message: "Please Provide Key Input", actionText: "Retry")
                self.present(alert, animated: true, completion: nil)
            } else if message.isEmpty {
                let alert = UIAlertController.createActionView(title: "Error", message: "Please Provide Message Input", actionText: "Retry")
                self.present(alert, animated: true, completion: nil)
            } else {
                handleMessageEncryption(key: key, message: message)
            }
        } else {
            let alert = UIAlertController.createActionView(title: "No Internet", message: "Device is not connected to internet", actionText: "Ok")
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func handleMessageEncryption(key: String, message: String) {
        ProgressHUD.show("Loading")
        let url = Config.baseUrl + "/insert"
        let params: [String: Any] = ["key": key]
        let data = ClientSide.clientEncryption(input: message, password: key)
        
        Api.encryptionRequest(url: url, coverImageData: selectedImage.pngData()!, hiddenImageData: data, parameters: params, onCompletion: { (link) -> (Void) in
            ProgressHUD.dismiss()
            self.insertedImageLink = link
            self.performSegue(withIdentifier: "MessageToResult_Segue", sender: link)
        }) { (error) in
            ProgressHUD.dismiss()
            let alert = UIAlertController.createActionView(title: "Error", message: error, actionText: "Retry")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MessageToResult_Segue" {
            let resultVC = segue.destination as! EncryptionResultViewController
            resultVC.link = insertedImageLink
        }
    }
    
}

extension Array where Element == UInt8 {
    var data : Data {
        return Data(bytes:(self))
    }
}
