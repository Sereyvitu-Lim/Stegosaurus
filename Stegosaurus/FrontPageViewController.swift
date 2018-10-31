//
//  FrontPageViewController.swift
//  Stegosaurus
//
//  Created by Sereyvitu Lim on 10/15/18.
//  Copyright © 2018 com.SereyvituLim. All rights reserved.
//

import UIKit

class FrontPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        view.isUserInteractionEnabled = true
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        view.isUserInteractionEnabled = true
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
                let controller = storyboard.instantiateViewController(withIdentifier: "EncryptNavID")
                self.present(controller, animated: false, completion: nil)
            }
        })
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
                let controller = storyboard.instantiateViewController(withIdentifier: "DecryptNavID")
                self.present(controller, animated: false, completion: nil)
            }
        })
    }
    
}
