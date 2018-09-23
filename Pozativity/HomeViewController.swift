//
//  HomeViewController.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 22/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import UIKit
import PDFKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var contractsTableView: UITableView!
    
    var contracts = [Contract]()
    var selectedRowIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contractsTableView.dataSource = self
        contractsTableView.delegate = self
        contractsTableView.rowHeight = 96
        contractsTableView.separatorStyle = .none
        contractsTableView.backgroundColor = .mgGray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContract))
        
        StorageService.isUserTrusted(completion: { (isTrusted) in
            if !isTrusted {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.showQR))
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ContractService.retrieveContracts { (contracts) in
            self.contracts = contracts
            self.contractsTableView.reloadData()
        }
    }
    
    @objc func showQR() {
        let image = generateQRCode(from: User.current.uid)
        
        if let qrVC = storyboard?.instantiateViewController(withIdentifier: "qr") as? QRViewController {
            qrVC.qrImage = image
            
            qrVC.modalPresentationStyle = .custom
            navigationController?.pushViewController(qrVC, animated: true)
            
        }
        
        if let newVC = storyboard?.instantiateViewController(withIdentifier: "mail") {
            
        }
        
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    @objc func addContract() {
        guard let path = Bundle.main.url(forResource: "contract1", withExtension: "pdf"),
            let document = PDFDocument(url: path) else { return }
        
        struct DummyContract {
            var deadline: String
            var contractor: String
            var title: String
        }
        
        var dummyData: [DummyContract] = [DummyContract(deadline: "25/9/2018", contractor: "Vodafone", title: "RED 12"),
                                          DummyContract(deadline: "29/9/1018", contractor: "Vodafone", title: "RED 15"),
                                          DummyContract(deadline: "25/9/2018", contractor: "Vodafone", title: "RED 19"),
                                          DummyContract(deadline: "7/10/2018", contractor: "Vodafone", title: "Super RED 25"),
                                          DummyContract(deadline: "9/10/2018", contractor: "Vodafone", title: "Smart 8"),
                                          DummyContract(deadline: "13/10/2018", contractor: "Vodafone", title: "Smart 10"),
                                          DummyContract(deadline: "2/11/2018", contractor: "Vodafone", title: "Acord GDPR"),
                                          DummyContract(deadline: "18/11/2018", contractor: "ICHB", title: "Contract Scoala")]
        
        dummyData.shuffle()
        for data in dummyData {
            ContractService.createContract(with: document, deadline: data.deadline, contractor: data.contractor, title: data.title) { (contract) in
                print(contract)
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier
        
        switch id {
        case "showDetailedContract":
            guard let destination = segue.destination as? DetailedContractViewController else {
                fatalError("el problemo segue")
            }
            
            destination.contract = contracts[selectedRowIndex]
        default:
            fatalError("unknown id")
        }
    }
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contracts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contractsTableView.dequeueReusableCell(withIdentifier: "contractsCell", for: indexPath) as? ContractTableViewCell else {
            assertionFailure("unknown cell")
            return UITableViewCell()
        }
        
        let contract = contracts[indexPath.row]
        
        cell.titleLabel.text = contract.title
        cell.contractorLabel.text = contract.contractor
        cell.deadlineDateLabel.text = contract.deadline
        
        return cell
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowIndex = indexPath.row
        performSegue(withIdentifier: "showDetailedContract", sender: self)
    }
}
