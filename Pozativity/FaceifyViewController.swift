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

class FaceifyViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var informationLabel: UILabel!
    
    @IBAction func scanButtonPressed(_ sender: Any) {
        guard UIImagePickerController.isCameraDeviceAvailable(.front) ||
            UIImagePickerController.isCameraDeviceAvailable(.rear) else { return }
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    var imagePicker = UIImagePickerController()
    var contract: Contract!
    var picturesTaken = 0
    var loader = NVActivityIndicatorView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loaderFrame = CGRect(x: self.view.bounds.midX - 30, y: self.view.bounds.midY - 30, width: 60, height: 60)
        loader = NVActivityIndicatorView(frame: loaderFrame, type: NVActivityIndicatorType(rawValue: 26), color: .mgDestructive, padding: nil)
        
        picturesTaken = 0
        title = "Sign Document"
        
        informationLabel.text = "Verify identity by scanning your id card, make sure you take a clear picture."
        informationLabel.textColor = UIColor.mgSubtitle
        
        view.backgroundColor = .mgGray
        
        imagePicker.delegate = self
//        imagePicker.cameraDevice = .rear
        
        containerView.layer.cornerRadius = Constants.cornerRadius
        containerView.layer.setUpShadow()
        
        scanButton.setUp(withColor: .mgInformative)
        scanButton.layer.setUpShadow()
        
        
        
    }
    
    private func showAnimation() {
        UIView.animate(withDuration: 0.25) {
            self.view.addSubview(self.loader)
            self.blurView.isHidden = false
            self.loader.startAnimating()
        }
    }
    
    private func hideAnimation() {
        UIView.animate(withDuration: 0.25) {
            self.loader.removeFromSuperview()
            self.blurView.isHidden = false
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

                
            }
        }
        
        dismiss(animated: true) {
            if self.picturesTaken == 2 {
                //TODO: kek with radu
                
                self.showAnimation()
                
                guard let url = URL(string: "https://brave-frog-53.localtunnel.me/") else {
                    return
                }
                
                Alamofire.request(url, method: .get, parameters: ["id": self.contract.uid, "uid": User.current.uid] ).responseJSON { (dataResponse) in
                    if dataResponse.response?.statusCode == 200 {
                        ContractService.signContract(self.contract)
                    } else if dataResponse.response?.statusCode == 403 {
                        //not matching
                    } else if dataResponse.response?.statusCode == 400 {
                        //could not connect with the server
                    }
                    
                    self.hideAnimation()
                }
                
            }
        }
        
    }
}

extension FaceifyViewController: UINavigationControllerDelegate {
    
}
