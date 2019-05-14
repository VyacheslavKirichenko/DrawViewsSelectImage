//
//  ViewController.swift
//  DrawViews
//
//  Created by VyacheslavKrivoi on 4/14/19.
//  Copyright © 2019 VyacheslavKrivoi. All rights reserved.
//

import UIKit

struct Constants {
    static var flipCardAnimationDuration: TimeInterval = 0.9
    static var matchCardAnimationDuration: TimeInterval = 0.9
    static var matchCardAnimationScaleUp: CGFloat = 1.5
    static var matchCardAnimationScaleDown: CGFloat = 1.5
    static var behaviorResistance: CGFloat = 0
    static var behaviorElasticity: CGFloat = 1.0
    static var behaviorPushMagnitudeMinimum: CGFloat = 0.5
    static var behaviorPushMagnitudeRandomFactor: CGFloat = 1.0
    static var cardsPerMainViewWidth: CGFloat = 1
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var pushBehaviors: [UIPushBehavior]=[]
    var flagIsFlip:Bool = false
    var imageView = UIImageView(image: UIImage(named: "cardBack")) // defaultImage
    
    private lazy var animator = UIDynamicAnimator(referenceView: view)
    private lazy var viewBehavior = ViewBehavior(in: animator)
    
    var viewCollection: Array<UIView> = [SubView1(frame: CGRect(x:30, y: 50, width: 98, height: 150)), SubView2(frame: CGRect(x:158, y: 50, width: 98, height: 150)), SubView3(frame: CGRect(x:286, y: 50, width: 98, height: 150)), SubView4(frame: CGRect(x:30, y: 220, width: 98, height: 150)), SubView5(frame: CGRect(x:158, y: 220, width: 98, height: 150)), SubView6(frame: CGRect(x:286, y: 220, width: 98, height: 150))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       initCollectionViews()
    }
    
    @IBAction func btnSetImage(_ sender: Any) {
        
      tapToImageView()
    }
    @IBAction func flipView(_ sender: UITapGestureRecognizer) {
       
        for i in view!.subviews {
            i.isHidden = true
        }
            sender.view?.isHidden = false
            viewBehavior.removeItem(sender.view!)
            if flagIsFlip != true   {
                sender.view!.viewAnimationToMax(completion: nil)
                if imageView.superview != sender.view {
                    sender.view!.addSubview(imageView)
                }
                imageView.isHidden = false
                flagIsFlip=true
            }else{
                
                imageView.isHidden = true
                flagIsFlip = false
                
                for i in view!.subviews {
                    i.isHidden = false
                }
                sender.view!.viewAnimationToMin(completion: nil)
                viewBehavior.addItem(sender.view!)
            }
    }
    func initCollectionViews()  {
        for i in 0...viewCollection.count-1{
            self.view.addSubview(viewCollection[i])
        }
        for cardView in viewCollection {
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipView(_:))))
            viewBehavior.addItem(cardView)
        }
    }
    
    @objc func tapToImageView() {
        print("tap to imageView")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary;
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
}

