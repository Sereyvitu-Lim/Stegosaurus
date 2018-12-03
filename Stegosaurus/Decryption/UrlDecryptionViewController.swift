//
//  UrlDecryptionViewController.swift
//  Stegosaurus
//
//  Created by Sereyvitu Lim on 10/27/18.
//  Copyright © 2018 com.SereyvituLim. All rights reserved.
//

import UIKit
import ProgressHUD

class UrlDecryptionViewController: UIViewController {
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var decryptButton: UIButton!
    
    var returnedText: String?
    var returnedData: Data?
    
    var decryptedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func decryptButton_TouchUpInside(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {
            guard let urlText = urlTextField.text, let key = keyTextField.text else { return }
            
            if urlText.isEmpty && key.isEmpty {
                let alert = UIAlertController.createActionView(title: "Error", message: "Please Provide Both Url and Key Inputs", actionText: "Retry")
                present(alert, animated: true, completion: nil)
            } else if urlText.isEmpty {
                let alert = UIAlertController.createActionView(title: "Error", message: "Please Provide Url Input", actionText: "Retry")
                present(alert, animated: true, completion: nil)
            } else if key.isEmpty {
                let alert = UIAlertController.createActionView(title: "Error", message: "Please Provide Key Input", actionText: "Retry")
                present(alert, animated: true, completion: nil)
            } else {
                handleUrlDecryption(urlText: urlText, key: key)
            }
        } else {
            let alert = UIAlertController.createActionView(title: "No Internet", message: "Device is not connected to internet", actionText: "Ok")
            present(alert, animated: true, completion: nil)
        }
        
        ///***/// no client side decryption
        
//        ProgressHUD.show("Loading")
//        let url = Config.baseUrl + "/extract"
//        let params: [String: Any] = ["image_url": urlTextField.text!, "key": keyTextField.text!]
//        Api.decryptionRequest(url: url, parameters: params, onCompletion: { (data, text) -> (Void) in
//            ProgressHUD.dismiss()
//            self.returnedText = text
//            self.returnedData = data
//            if let text = text {
//                self.performSegue(withIdentifier: "ImageUrlToResult_Segue", sender: [data, text])
//            } else {
//                self.performSegue(withIdentifier: "ImageUrlToResult_Segue", sender: data)
//            }
//        }) { (error) in
//            ProgressHUD.dismiss()
//            let alert = UIAlertController.createActionView(title: "Error", message: error, actionText: "Retry")
//            self.present(alert, animated: true, completion: nil)
//        }
    }
    
    private func handleUrlDecryption(urlText: String, key: String) {
        ProgressHUD.show("Loading")
        let url = Config.baseUrl + "/extract"
        let params: [String: Any] = ["image_url": urlText, "key": key]
        
        Api.decryptionRequest(url: url, parameters: params, onCompletion: { (data, text) -> (Void) in
            ProgressHUD.dismiss()
            ClientSide.clientDecryptionImage(content: data, password: key, onCompleted: { (decryptedData) -> (Void) in
                let image = UIImage(data: decryptedData)
                self.handleDecryptionDataNavigation(image: image, data: data, key: key)
            }, onError: { (error) -> (Void) in
                let alert = UIAlertController.createActionView(title: "Error", message: error, actionText: "Ok")
                self.present(alert, animated: true, completion: nil)
            })
        }) { (error) in
            ProgressHUD.dismiss()
            let alert = UIAlertController.createActionView(title: "Error", message: error, actionText: "Retry")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func handleDecryptionDataNavigation(image: UIImage? = nil, data: Data, key: String) {
        if image == nil {
            ClientSide.clientDecryption(content: data, password: key, onCompleted: { (decryptedText) -> (Void) in
                self.returnedText = decryptedText
                self.performSegue(withIdentifier: "ImageUrlToResult_Segue", sender: decryptedText)
            }, onError: { (error) -> (Void) in
                let alert = UIAlertController.createActionView(title: "Error", message: error, actionText: "Ok")
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            self.decryptedImage = image
            self.performSegue(withIdentifier: "ImageUrlToResult_Segue", sender: image)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageUrlToResult_Segue" {
            let resultVC = segue.destination as! DecryptionResultViewController
            resultVC.requestedImage = decryptedImage
            resultVC.requestedString = returnedText
        }
    }

}
