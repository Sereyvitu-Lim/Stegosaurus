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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func decryptButton_TouchUpInside(_ sender: Any) {
        ProgressHUD.show("Loading")
        let url = Config.baseUrl + "/extract"
        let params: [String: Any] = ["image_url": urlTextField.text!, "key": keyTextField.text!]
        Api.decryptionRequest(url: url, parameters: params, onCompletion: { (data, text) -> (Void) in
            ProgressHUD.dismiss()
            self.returnedText = text
            self.returnedData = data
            if let text = text {
                self.performSegue(withIdentifier: "ImageUrlToResult_Segue", sender: [data, text])
            } else {
                self.performSegue(withIdentifier: "ImageUrlToResult_Segue", sender: data)
            }
        }) { (error) in
            ProgressHUD.dismiss()
            let alert = UIAlertController.createActionView(title: "Error", message: error, actionText: "Retry")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageUrlToResult_Segue" {
            let resultVC = segue.destination as! DecryptionResultViewController
            resultVC.requestedData = returnedData
            resultVC.requestedString = returnedText
        }
    }

}
