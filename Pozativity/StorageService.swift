//
//  StorageService.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 22/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import Foundation
import PDFKit
import FirebaseStorage
import UIKit

struct StorageService {
    static func uploadContract(_ contract: PDFDocument, at reference: StorageReference, completion: @escaping (URL?) -> ()) {

        
        guard let pdfData = contract.dataRepresentation() else {
            assertionFailure("could not get pdf")
            return completion(nil)
        }
        
        reference.putData(pdfData, metadata: nil) { (_, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                
                completion(url)
            })
        }
    }
    
    static func uploadBuletin(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 0.69) else {
            return completion(nil)
        }
        
        reference.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                
                completion(url)
            })
        }
    }
    
    static func isUserTrusted(completion: @escaping (Bool) -> ()) {
        let ref = Storage.storage().reference().child("trusted").child(User.current.uid)
        
        ref.getMetadata { (metadata, error) in
            if let error = error {
                completion(false)
            }
            completion(true)
        }
    }
    
    
}
