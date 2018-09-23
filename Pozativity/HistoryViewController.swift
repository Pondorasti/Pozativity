//
//  HistoryViewController.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 23/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var contractsTableView: UITableView!
    
    var contracts = [Contract]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contractsTableView.dataSource = self
        contractsTableView.delegate = self
        contractsTableView.rowHeight = 96
        contractsTableView.separatorStyle = .none
        contractsTableView.backgroundColor = .mgGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ContractService.retrieveOldContracts() { (contracts) in
            self.contracts = contracts
            self.contractsTableView.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contracts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contractsTableView.dequeueReusableCell(withIdentifier: "oldContractsCell", for: indexPath) as? OldContractsTableViewCell else {
            fatalError()
        }
        
        let contract = contracts[indexPath.row]
        
        cell.titleLabel.text = contract.title
        cell.contractorLabel.text = contract.contractor
        
        switch contract.state {
        case .decline:
            cell.tagView.backgroundColor = .mgDestructive
            cell.tagLabel.text = "Declined"
        case .signed:
            cell.tagView.backgroundColor = .mgInformative
            cell.tagLabel.text = "Signed"
        default:
            print("poof")
        }
        
        return cell
    }
    
    
}

extension HistoryViewController: UITableViewDelegate {
    
}
