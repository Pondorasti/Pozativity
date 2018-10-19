//
//  FaceifyViewController.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 22/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import UIKit
import Vision
import Firebase
import AVKit
import Alamofire
import NVActivityIndicatorView
import Lottie

class FaceifyViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var informationLabel: UILabel!
    
    @IBAction func scanButtonPressed(_ sender: Any) {
        guard UIImagePickerController.isCameraDeviceAvailable(.front) ||
            UIImagePickerController.isCameraDeviceAvailable(.rear) else { return }
        imagePicker.sourceType = .camera
        
        scanButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: [], animations: {
            self.scanButton.transform = .identity
        }) { (_) in
            self.present(self.imagePicker, animated: true)
        }
    }
    
    var imagePicker = UIImagePickerController()
    var contract: Contract!
    var picturesTaken = 0
    var loader = NVActivityIndicatorView(frame: CGRect())
    var succesLottie = LOTAnimationView(name: "success_animation")
    var failureLottie = LOTAnimationView(name: "error_cross")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loaderFrame = CGRect(x: self.view.bounds.midX - 50, y: self.view.bounds.midY - 50, width: 100, height: 100)
        
        succesLottie.frame = loaderFrame
        succesLottie.animationSpeed = 1
        
        failureLottie.frame = loaderFrame
        failureLottie.animationSpeed = 1
        
        loader = NVActivityIndicatorView(frame: loaderFrame, type: NVActivityIndicatorType(rawValue: 22), color: .mgInformative, padding: nil)
        
        picturesTaken = 0
        title = "Sign Document"
        
        informationLabel.text = "To get acces to the medical prescription please verify identity by scanning your id card, make sure you take a clear picture."
        informationLabel.textColor = UIColor.mgSubtitle
        
        view.backgroundColor = .mgGray
        
        imagePicker.delegate = self
        
        containerView.layer.cornerRadius = Constants.cornerRadius
        containerView.layer.setUpShadow()
        
        scanButton.setUp(withColor: .mgInformative)
        scanButton.layer.setUpShadow()
        
        blurView.isHidden = false
        blurView.alpha = 0
    }
    
    private func showAnimation() {
        UIView.animate(withDuration: 0.25, animations: {
            self.blurView.alpha = 1
        }) { (_) in
            self.view.addSubview(self.loader)
            self.loader.startAnimating()
        }
    }
    
    private func hideAnimation(andShowSucces showSucces: Bool = false) {
        
        loader.removeFromSuperview()
        
        if showSucces {
            view.addSubview(self.succesLottie)
            succesLottie.play(completion: { (_) in
                
                self.informationLabel.text = "Identity verified"
                self.performSegue(withIdentifier: "showPDF2", sender: nil)
                
            })
            
        } else {
            view.addSubview(self.failureLottie)
            failureLottie.play(completion: { (_) in
                self.failureLottie.removeFromSuperview()
                UIView.animate(withDuration: 0.25, animations: {
                    self.blurView.alpha = 0
                }, completion: { (_) in
                    
                })
            })
            
        }
    }
    
    private func APIRequest() {
        guard let url = URL(string: "https://rotten-bird-33.localtunnel.me/") else {
            return
        }
        
        Alamofire.request(url, method: .post, parameters: ["id": self.contract.uid, "uid": User.current.uid] ).responseJSON { (dataResponse) in
            if dataResponse.response?.statusCode == 200 {
                ContractService.signContract(self.contract)
                self.hideAnimation(andShowSucces: true)
            } else {
                self.picturesTaken = 0
                self.informationLabel.textColor = .mgDestructive
                self.hideAnimation()
                self.scanButton.setTitle("Scan again", for: .normal)
                
                if dataResponse.response?.statusCode == 403 {
                    self.informationLabel.text = "Detected faces and text is not matching with our database, please try again."
                    
                } else if dataResponse.response?.statusCode == 400 {
                    self.informationLabel.text = "There was an error detecting faces and scanning text, please try again a bit later"
                }
            }
        }
    }
    
    //400 problem with processing
    //403 not matching
    //200 we good
}

extension FaceifyViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picturesTaken += 1
            
            let ref: StorageReference
            if picturesTaken == 1 {
                ref = Storage.storage().reference().child("buletin").child(contract.uid)
                self.informationLabel.text = "ID card scanned succesfully, continue by taking a selfie of yourself, make sure you take a clear picture."
            } else {
                ref = Storage.storage().reference().child("selfie").child(contract.uid)
            }
            
            StorageService.uploadBuletin(pickedImage, at: ref) { (url) in
                if self.picturesTaken == 2 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
//                        self.APIRequest()
                        
                        self.hideAnimation(andShowSucces: true)
                    })
                }
            }
        }
        
        dismiss(animated: true) {
            if self.picturesTaken == 2 {
                self.showAnimation()
            }
        }
        
    }
}

extension FaceifyViewController: UINavigationControllerDelegate {
    
}
