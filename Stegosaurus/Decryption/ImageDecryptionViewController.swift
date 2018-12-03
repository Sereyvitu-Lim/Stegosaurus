//
//  ImageDecryptionViewController.swift
//  Stegosaurus
//
//  Created by Sereyvitu Lim on 10/27/18.
//  Copyright © 2018 com.SereyvituLim. All rights reserved.
//

import UIKit
import ProgressHUD

class ImageDecryptionViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var keyTextField: UITextField!
    
    var returnedText: String?
    var selectedImage: UIImage?
    var decryptedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photoImageView.addGestureRecognizer(tapGesture)
        photoImageView.isUserInteractionEnabled = true
    }
    
    @IBAction func decryptionButton_TouchUpInside(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {
            guard let key = keyTextField.text else { return }
            
            if selectedImage == nil && key.isEmpty {
                let alert = UIAlertController.createActionView(title: "Error", message: "Please Provide Both Image and Key Inputs", actionText: "Retry")
                present(alert, animated: true, completion: nil)
            } else if selectedImage == nil {
                let alert = UIAlertController.createActionView(title: "Error", message: "Please Provide Image Input", actionText: "Retry")
                present(alert, animated: true, completion: nil)
            } else if key.isEmpty {
                let alert = UIAlertController.createActionView(title: "Error", message: "Please Provide Key Input", actionText: "Retry")
                present(alert, animated: true, completion: nil)
            } else {
                handleImageDecryption(key: key)
            }
        } else {
            let alert = UIAlertController.createActionView(title: "No Internet", message: "Device is not connected to internet", actionText: "Ok")
            present(alert, animated: true, completion: nil)
        }
        
//        let url = Config.baseUrl + "/extract"
//        let params: [String: Any] = ["key": keyTextField.text!]
//        ProgressHUD.show("Loading")
//        Api.decryptionRequest(url: url, imageData: selectedImage?.pngData(), parameters: params, onCompletion: { (data, text) -> (Void) in
//            ProgressHUD.dismiss()
//            self.returnedText = text
//            self.returnedData = data
//            if let text = text {
//                self.performSegue(withIdentifier: "ImageToResult_Segue", sender: [data, text])
//            } else {
//                self.performSegue(withIdentifier: "ImageToResult_Segue", sender: data)
//            }
//        }) { (error) in
//            ProgressHUD.dismiss()
//            let alert = UIAlertController.createActionView(title: "Error", message: error, actionText: "Retry")
//            self.present(alert, animated: true, completion: nil)
//        }
    }
    
    private func handleImageDecryption(key: String) {
        ProgressHUD.show("Loading")
        let url = Config.baseUrl + "/extract"
        let params: [String: Any] = ["key": key]
        
        Api.decryptionRequest(url: url, imageData: selectedImage?.pngData(), parameters: params, onCompletion: { (data, text) -> (Void) in
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
                self.performSegue(withIdentifier: "ImageToResult_Segue", sender: decryptedText)
            }, onError: { (error) -> (Void) in
                let alert = UIAlertController.createActionView(title: "Error", message: error, actionText: "Ok")
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            self.decryptedImage = image
            self.performSegue(withIdentifier: "ImageToResult_Segue", sender: image)
        }
    }
    
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image"]
        present(pickerController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageToResult_Segue" {
            let resultVC = segue.destination as! DecryptionResultViewController
            resultVC.requestedImage = decryptedImage
            resultVC.requestedString = returnedText
        }
    }
    
}

extension ImageDecryptionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            photoImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}
