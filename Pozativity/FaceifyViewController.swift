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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        let loaderFrame = CGRect(x: view.bounds.midX - 30, y: view.bounds.midY - 30, width: 60, height: 60)
        let loader = NVActivityIndicatorView(frame: loaderFrame, type: NVActivityIndicatorType(rawValue: 26), color: .mgDestructive, padding: nil)
        
//        view.addSubview(loader)
//        loader.startAnimating()
    }
    
//    guard let url = URL(string: "https://webhook.site/d3c70045-011b-4e2b-a6ef-fa145e4923f5") else {
//    return
//    }
//
//    Alamofire.request(url, method: .get, parameters: nil).validate().responseJSON { (response) in
//    print(response.response?.statusCode)
//    print(response.data as? [String: Any])
//    }

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
                    //TODO: kek with radu
                }
            }
        }
        
        dismiss(animated: true)
        
    }
}

extension FaceifyViewController: UINavigationControllerDelegate {
    
}
