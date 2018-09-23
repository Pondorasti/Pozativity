//
//  ViewController.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 22/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FirebaseAuth

class LogInViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        
        logInButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: [], animations: {
            self.logInButton.transform = .identity
        }) { (_) in
            self.logInUser()
        }
    }
    
    private func logInUser() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                assertionFailure("mail or password missing")
                return
        }
        
        
        let loaderFrame = CGRect(x: self.view.bounds.midX - 50, y: self.view.bounds.midY - 50, width: 100, height: 100)
        let loader = NVActivityIndicatorView(frame: loaderFrame, type: NVActivityIndicatorType(rawValue: 30), color: .mgInformative, padding: nil)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.blurView.alpha = 1
        }) { (_) in
            self.blurView.contentView.addSubview(loader)
            loader.startAnimating()
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
        
        view.backgroundColor = .mgGray
        
        titleLabel.textColor = .mgTitle
        emailTitleLabel.textColor = .mgTitle
        passwordTitleLabel.textColor = .mgTitle
        passwordTextField.isSecureTextEntry = true
        
        emailTextField.layer.setUpShadow()
        passwordTextField.layer.setUpShadow()
        
        logInButton.layer.cornerRadius = Constants.cornerRadius
        logInButton.setUp(withColor: .mgInformative)
        logInButton.layer.setUpShadow()
        
        blurView.isHidden = false
        blurView.alpha = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}


