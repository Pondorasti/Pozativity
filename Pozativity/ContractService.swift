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
    
    static func retrieveContracts(completion: @escaping ([Contract]) -> ()) {
        let ref = Database.database().reference().child("contracts")
        
        ref.observe(.value) { (snapshot) in
            guard let snapshotValues = snapshot.children.allObjects as? [DataSnapshot] else {
                fatalError("el problemo")
            }
            
            let contracts: [Contract] = snapshotValues.compactMap({ (snapshot) -> Contract in
                guard let contract = Contract(snapshot: snapshot) else {
                    fatalError("second el problemo")
                }
                
                return contract
            })
            
            completion(contracts)
        }
    }
    
    static func retrieveOldContracts(completion: @escaping ([Contract]) -> ()) {
        let ref = Database.database().reference().child("oldContracts")
        
        ref.observe(.value) { (snapshot) in
            guard let snapshotValues = snapshot.children.allObjects as? [DataSnapshot] else {
                fatalError("el problemo")
            }
            
            let contracts: [Contract] = snapshotValues.compactMap({ (snapshot) -> Contract in
                guard let contract = Contract(snapshot: snapshot) else {
                    fatalError("second el problemo")
                }
                
                return contract
            })
            
            completion(contracts)
        }
    }
    
    static func signContract(_ contract: Contract) {
        let ref = Database.database().reference().child("contracts").child(contract.uid)
        ref.setValue(nil)
        
        let ref2 = Database.database().reference().child("oldContracts").child(contract.uid)
        
        let oldContract = Contract(uid: contract.uid, deadline: contract.deadline, contractor: contract.contractor, pdfURL: contract.pdfURL, title: contract.title, state: .signed)
        ref2.updateChildValues(oldContract.dictValue)
    }
    
    
    static func declineContract(_ contract: Contract) {
        let ref = Database.database().reference().child("contracts").child(contract.uid)
        ref.setValue(nil)
        
        let ref2 = Database.database().reference().child("oldContracts").child(contract.uid)
        
        let oldContract = Contract(uid: contract.uid, deadline: contract.deadline, contractor: contract.contractor, pdfURL: contract.pdfURL, title: contract.title, state: .decline)
        ref2.updateChildValues(oldContract.dictValue)
    }
}
