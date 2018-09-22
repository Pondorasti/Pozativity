//
//  DetailedContractViewController.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 22/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import UIKit
import WebKit

class DetailedContractViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contractorLabel: UILabel!
    
    @IBOutlet weak var deadlineTitleLabel: UILabel!
    @IBOutlet weak var deadlineDateLabel: UILabel!
    
    @IBOutlet weak var showPDFButton: UIButton!
    @IBOutlet weak var signDocumentButton: UIButton!
    
    @IBAction func showPDFButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showPDF", sender: self)
    }
    
    @IBAction func signDocumentButtonPressed(_ sender: Any) {
        
    }
    
    var contract: Contract!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier
        
        switch id {
        case "showPDF":
            guard let destination = segue.destination as? PDFViewController,
                let url = URL(string: contract.pdfURL) else {
                return assertionFailure("pdf problem")
            }
            
            destination.urlToShow = url
        default:
            assertionFailure("unknown id")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = contract.title
        contractorLabel.text = contract.contractor
        deadlineDateLabel.text = contract.deadline
    }

}
