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
    var returnedData: Data?
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photoImageView.addGestureRecognizer(tapGesture)
        photoImageView.isUserInteractionEnabled = true
    }
    
    @IBAction func decryptionButton_TouchUpInside(_ sender: Any) {
        let url = Config.baseUrl + "/extract"
        let params: [String: Any] = ["key": keyTextField.text!]
        ProgressHUD.show("Loading")
        Api.decryptionRequest(url: url, imageData: selectedImage?.pngData(), parameters: params, onCompletion: { (data, text) -> (Void) in
            ProgressHUD.dismiss()
            self.returnedText = text
            self.returnedData = data
            if let text = text {
                self.performSegue(withIdentifier: "ImageToResult_Segue", sender: [data, text])
            } else {
                self.performSegue(withIdentifier: "ImageToResult_Segue", sender: data)
            }
        }) { (error) in
            ProgressHUD.dismiss()
            let alert = UIAlertController.createActionView(title: "Error", message: error, actionText: "Retry")
            self.present(alert, animated: true, completion: nil)
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
            resultVC.requestedData = returnedData
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
