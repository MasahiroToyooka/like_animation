//
//  ViewController.swift
//  like_animation
//
//  Created by 豊岡正紘 on 2019/01/10.
//  Copyright © 2019 豊岡正紘. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "facebookBackgroundImage")
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return imageView
    }()
    
    
    let iconsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        let iconHeight: CGFloat = 50
        let padding: CGFloat = 8
        
        let images = ["Like", "Love", "Wow", "Haha", "Sad", "Angry"]
        
        let arrangedSubviews = images.map({ (image) -> UIView in
            
            let imageView = UIImageView()
            imageView.image = UIImage(named: image)
            imageView.layer.cornerRadius = iconHeight / 2
            
            // required for hit testing
            imageView.isUserInteractionEnabled = true
            return imageView
        })
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding
            , bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        containerView.addSubview(stackView)
        
        let numIcons = CGFloat(arrangedSubviews.count)
        let width = iconHeight * numIcons + padding * (numIcons + 1)
        
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + padding * 2)
        containerView.layer.cornerRadius = containerView.frame.height / 2
        
        //shadow
        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        
        stackView.frame = containerView.frame

        return containerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgImage)
        
        setupLongPressGesture()
    }
    
    fileprivate func setupLongPressGesture(){
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer){
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
        } else if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: 50)
                self.iconsContainerView.alpha = 0
            }, completion: { (_) in
                self.iconsContainerView.removeFromSuperview()
            })
        } else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
    }
    
    fileprivate func handleGestureChanged(gesture: UILongPressGestureRecognizer) {
        let pressedLocation = gesture.location(in: self.iconsContainerView)
        print(pressedLocation)
        
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.iconsContainerView.frame.height / 2)
        
        let hitTestView = iconsContainerView.hitTest(fixedYLocation, with: nil)
        if hitTestView is UIImageView {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
            })
        }
    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        
        view.addSubview(iconsContainerView)
        
        let pressedLocation = gesture.location(in: self.view)
        print(pressedLocation)
        
        let centeredX = (view.frame.width - iconsContainerView.frame.width) / 2
        
        iconsContainerView.alpha = 0
        iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.iconsContainerView.alpha = 1
            self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.iconsContainerView.frame.height)
        })
    }
    
    override var prefersStatusBarHidden: Bool {return true}

}

