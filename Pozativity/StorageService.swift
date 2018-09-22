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

struct StorageService {
    static func uploadContract(_ contract: PDFDocument, at reference: StorageReference, completion: @escaping (URL?) -> ()) {
//        let ref = Storage.storage().reference().child("contracts").child(user.uid)
        
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
}