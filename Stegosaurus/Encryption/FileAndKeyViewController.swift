//
//  FileAndKeyViewController.swift
//  Stegosaurus
//
//  Created by Sereyvitu Lim on 10/27/18.
//  Copyright © 2018 com.SereyvituLim. All rights reserved.
//

import UIKit
import ProgressHUD

class FileAndKeyViewController: UIViewController {
    
    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var encryptButton: UIButton!
    
    var chosenImage: UIImage?
    var coverImage: UIImage?
    
    var insertedImageLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func chooseFileButton_TouchUpInside(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image"]
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func encryptButton_TouchUpInside(_ sender: Any) {
        ProgressHUD.show("Loading")
        let url = Config.baseUrl + "/insert"
        let params = ["key": keyTextField.text!]
        if let coverImage = coverImage, let chosenImage = chosenImage {
            Api.encryptionRequest(url: url, coverImageData: coverImage.pngData()!, hiddenImageData: chosenImage.pngData(), parameters: params, onCompletion: { (link) -> (Void) in
                ProgressHUD.dismiss()
                self.insertedImageLink = link
                self.performSegue(withIdentifier: "FileToResult_Segue", sender: link)
            }) { (error) in
                ProgressHUD.dismiss()
                let alert = UIAlertController.createActionView(title: "Error", message: error, actionText: "Retry")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FileToResult_Segue" {
            let resultVC = segue.destination as! EncryptionResultViewController
            resultVC.link = insertedImageLink
        }
    }
    
}

extension FileAndKeyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            chosenImage = image
            selectedImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}
