//
//  EncryptionViewController.swift
//  Stegosaurus
//
//  Created by Sereyvitu Lim on 10/15/18.
//  Copyright © 2018 com.SereyvituLim. All rights reserved.
//

import UIKit

class EncryptionViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    var selectedImage: UIImage?
    var defaultImages = [DefaultImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        defaultImages = DefaultImage.createDefaultImageArray()
        
        addSwipeGestureToView()
        addTapGestureToImageView()
    }
    
    private func addSwipeGestureToView() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        view.isUserInteractionEnabled = true
    }
    
    private func addTapGestureToImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func handleSwipeLeft() {
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
    
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image"]
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func nextButton_TouchUpInside(_ sender: Any) {
        if selectedImage == nil {
            let alert = UIAlertController.createActionView(title: "Error", message: "Please Select an Image", actionText: "Retry")
            present(alert, animated: true, completion: nil)
        } else {
            let actionSheet = UIAlertController(title: "Stegosaurus", message: "What type of file would you like to hide?", preferredStyle: .actionSheet)
            let textAction = UIAlertAction(title: "Text message", style: .default) { (_) in
                self.performSegue(withIdentifier: "EncryptToMessage_Segue", sender: self.selectedImage)
            }
            let filesAction = UIAlertAction(title: "Other files", style: .default) { (_) in
                self.performSegue(withIdentifier: "EncryptToFile_Segue", sender: self.selectedImage)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheet.addAction(textAction)
            actionSheet.addAction(filesAction)
            actionSheet.addAction(cancelAction)
            
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EncryptToMessage_Segue" {
            let messageVC = segue.destination as! MessageAndKeyViewController
            messageVC.selectedImage = selectedImage
        }
        
        if segue.identifier == "EncryptToFile_Segue" {
            let fileVC = segue.destination as! FileAndKeyViewController
            fileVC.coverImage = selectedImage
        }
    }
    
}

extension EncryptionViewController: DefaultImageSelectionDelegate {
    
    func didSelectDefaultImage(image: UIImage) {
        selectedImage = image
        imageView.image = image
    }
    
}

extension EncryptionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension EncryptionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaultImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultImageCell", for: indexPath) as! DefaultImageCollectionViewCell
        let image = defaultImages[indexPath.item]
        cell.image = image
        cell.delegate = self
        
        return cell
    }
    
}

extension EncryptionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 3 - 1), height: (collectionView.frame.size.width / 3 - 1))
    }
    
}
