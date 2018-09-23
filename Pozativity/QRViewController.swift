//
//  QRViewController.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 23/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import UIKit

class QRViewController: UIViewController {

    @IBOutlet weak var qrImageView: UIImageView!
    
    var qrImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registration QR"
        
        qrImageView.image = qrImage
        
        // Do any additional setup after loading the view.
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
