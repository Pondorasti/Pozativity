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
        
        imagePicker.delegate = self
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
