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

class FaceifyViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign-in Document"
        
        informationLabel.text = "Verify identity by scanning your id card, make sure you take a clear picture."
        informationLabel.textColor = UIColor.mgSubtitle
        
        view.backgroundColor = .mgGray
        
        imagePicker.delegate = self
        
        containerView.layer.cornerRadius = Constants.cornerRadius
        containerView.layer.setUpShadow()
        
        scanButton.setUp(withColor: .mgInformative)
        scanButton.layer.setUpShadow()
    }

}

extension FaceifyViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let ref = Storage.storage().reference().child("buletin").child(contract.uid)
            StorageService.uploadBuletin(pickedImage, at: ref) { (url) in
                print("url")
            }
        }
        
        dismiss(animated: true)
        
    }
}

extension FaceifyViewController: UINavigationControllerDelegate {
    
}
