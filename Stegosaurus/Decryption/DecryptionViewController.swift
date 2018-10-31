//
//  DecryptionViewController.swift
//  Stegosaurus
//
//  Created by Sereyvitu Lim on 10/15/18.
//  Copyright © 2018 com.SereyvituLim. All rights reserved.
//

import UIKit

class DecryptionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        view.isUserInteractionEnabled = true
    }
    
    @IBAction func getStartedButton_TouchUpInside(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Stegosaurus", message: "Please choose one of the followings method to decrypt", preferredStyle: .actionSheet)
        let imageAction = UIAlertAction(title: "Image", style: .default) { (_) in
            self.performSegue(withIdentifier: "DecryptionToImage_Segue", sender: nil)
        }
        let urlAction = UIAlertAction(title: "Image URL", style: .default) { (_) in
            self.performSegue(withIdentifier: "DecryptionToImageURL_Segue", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        actionSheet.addAction(imageAction)
        actionSheet.addAction(urlAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func handleSwipeRight() {
        UIView.animate(withDuration: 0
            , animations: {
                self.view.frame.origin = CGPoint(
                    x: self.view.frame.origin.x,
                    y: self.view.frame.size.height
                )
        }, completion: { (isCompleted) in
            if isCompleted {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "FrontPageNavID")
                self.present(controller, animated: false, completion: nil)
            }
        })
    }
    
}
