//
//  ContractsService.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 22/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import Foundation
import PDFKit
import FirebaseDatabase
import FirebaseStorage

struct ContractService {
    static func createContract(with pdf: PDFDocument, deadline: String, contractor: String, title: String,
                               completion: @escaping (Contract?) -> ()) {
        
        let ref = Database.database().reference().child("contracts").childByAutoId()
        let pdfRef = Storage.storage().reference().child("contracts").child(ref.key)
        StorageService.uploadContract(pdf, at: pdfRef) { (pdfURL) in
            guard let pdfURL = pdfURL else {
                assertionFailure("poof")
                return completion(nil)
            }
            
            let contract = Contract(uid: ref.key, deadline: deadline, contractor: contractor, pdfURL: pdfURL.absoluteString, title: title)
            ref.updateChildValues(contract.dictValue, withCompletionBlock: { (error, ref) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                }
                
                completion(contract)
            })
        }
    }
}
