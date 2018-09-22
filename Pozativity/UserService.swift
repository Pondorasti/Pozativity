//
//  UserService.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 22/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct UserService {
    static func retrieveUser(for uid: String, completion: @escaping (User?) -> ()) {
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            completion(User(from: snapshot))
        }
    }
}
