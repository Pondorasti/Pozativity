//
//  CreateAppointmentViewController.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 19/10/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import UIKit
import DropDown

class CreateAppointmentViewController: UIViewController {
    
    let hospitalPicker = DropDown()
    let dieseasePicker = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hospitalPicker.dataSource = ["State Hospital", "Medlife"]
        dieseasePicker.dataSource = ["Hepatitis B vaccine", "Brain Aging", "Osteoporosis", "Cancer Risk", "Allergies Test"]

        
        view.addSubview(hospitalPicker)
        view.addSubview(dieseasePicker)
        
        title = "Create Appointment"
        
        hospitalPicker.translatesAutoresizingMaskIntoConstraints = false
        dieseasePicker.translatesAutoresizingMaskIntoConstraints = false
        
        hospitalPicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
        hospitalPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        hospitalPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        
        dieseasePicker.topAnchor.constraint(equalTo: hospitalPicker.bottomAnchor, constant: 16)
        dieseasePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        dieseasePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        dieseasePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        
        let poof = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        poof.backgroundColor = .red
        
        view.addSubview(poof)
        
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
