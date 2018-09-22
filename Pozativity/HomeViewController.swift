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
        
        ContractService.retrieveContracts { (contracts) in
            self.contracts = contracts
            self.contractsTableView.reloadData()
        }
    }
    
    @objc func addContract() {
        guard let path = Bundle.main.url(forResource: "contract1", withExtension: "pdf"),
            let document = PDFDocument(url: path) else { return }
        
        ContractService.createContract(with: document, deadline: "12.12.12", contractor: "Alex", title: "Abonament Metrou") { (contract) in
            print(contract)
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
        //TODO: fix this
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
