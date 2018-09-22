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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contractsTableView.dataSource = self
        contractsTableView.delegate = self
        contractsTableView.rowHeight = 104
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContract))
    }
    
    @objc func addContract() {
        guard let path = Bundle.main.url(forResource: "contract1", withExtension: "pdf"),
            let document = PDFDocument(url: path) else { return }
        
        ContractService.createContract(with: document, deadline: "12.12.12", contractor: "Alex", title: "Abonament Metrou") { (contract) in
            print(contract)
        }

    }
    
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: fix this
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contractsTableView.dequeueReusableCell(withIdentifier: "contractsCell", for: indexPath) as? ContractTableViewCell else {
            assertionFailure("unknown cell")
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    
}
