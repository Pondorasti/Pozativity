//
//  ViewController.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 22/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        logInUser()
    }
    
    private func logInUser() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                assertionFailure("mail or password missing")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] (result, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            if let firUser = result?.user {
                UserService.retrieveUser(for: firUser.uid, completion: { (user) in
                    guard let user = user else {
                        assertionFailure("no user")
                        return
                    }
        
                    User.setCurrent(user)
                    self.performSegue(withIdentifier: "showHomeScreen", sender: self)
                })
            } else {
                assertionFailure("user uid not found")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }


}


