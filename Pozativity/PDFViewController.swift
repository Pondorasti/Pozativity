//
//  PDFViewController.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 22/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import UIKit
import WebKit

class PDFViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var urlToShow: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let path = Bundle.main.url(forResource: "Prescription", withExtension: "pdf") else { return }
        webView.loadFileURL(path, allowingReadAccessTo: path)
        
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
