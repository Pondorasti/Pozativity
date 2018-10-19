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

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var webContainerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contractorLabel: UILabel!
    
    @IBOutlet weak var deadlineTitleLabel: UILabel!
    @IBOutlet weak var deadlineDateLabel: UILabel!
    
    @IBOutlet weak var showPDFButton: UIButton!
    @IBOutlet weak var signDocumentButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func showPDFButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showPDF", sender: self)
    }
    
    @IBAction func signDocumentButtonPressed(_ sender: Any) {
        signDocumentButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: [], animations: {
            self.signDocumentButton.transform = .identity
        }) { (_) in
            self.performSegue(withIdentifier: "showCamera", sender: self)
        }
    }
    

    @IBAction func declineButtonPressed(_ sender: Any) {
        declineButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: [], animations: {
            self.declineButton.transform = .identity
        }) { (_) in
            let ac = UIAlertController(title: "Appointment", message: "Are you sure you want to continue?", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { (_) in
                ContractService.declineContract(self.contract)
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(ac, animated: true)
        }
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
        case "showCamera":
            guard let destination = segue.destination as? FaceifyViewController else {
                return assertionFailure("problem")
            }
            
            destination.contract = contract
            
            print("showing camera")
        default:
            assertionFailure("unknown id")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Appointment"
        view.backgroundColor = .mgGray
        
        containerView.layer.cornerRadius = Constants.cornerRadius
        containerView.layer.setUpShadow()
        
        webContainerView.layer.cornerRadius = Constants.cornerRadius
        webContainerView.layer.setUpShadow()
        webContainerView.backgroundColor = .mgWhite
        
        webView.backgroundColor = .mgWhite
        webView.layer.cornerRadius = Constants.cornerRadius
        webView.clipsToBounds = true

        titleLabel.text = contract.title
        contractorLabel.text = contract.contractor
        deadlineDateLabel.text = contract.deadline
        
        titleLabel.textColor = .mgTitle
        contractorLabel.textColor = .mgSubtitle
        
        deadlineDateLabel.textColor = .mgVodafone
        deadlineTitleLabel.textColor = .mgVodafone
        
        showPDFButton.setUp(withColor: .mgInformative)
        signDocumentButton.setUp(withColor: .mgInformative)
        declineButton.setUp(withColor: .mgDestructive)
        
        showPDFButton.layer.setUpShadow()
        signDocumentButton.layer.setUpShadow()
        declineButton.layer.setUpShadow()
        
        if let url = URL(string: contract.pdfURL) {
            webView.load(URLRequest(url: url))
        } else {
            fatalError("no u pdf")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let url = URL(string: contract.pdfURL) {
            webView.load(URLRequest(url: url))
        } else {
            fatalError("no u pdf")
        }
        
    }

}
