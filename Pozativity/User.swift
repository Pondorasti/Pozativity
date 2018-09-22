//
//  User.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 22/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//


import FirebaseAuth
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

struct User {
    let uid: String
    let name: String
    let officialPhotoURL: String? = nil
    
    private static var _current: User?
    
    public var dictValue: [String: Any] {
        return ["name": name,
                "uid": uid,
                "officialPhotoURL": officialPhotoURL]
    }
    
    public static var current: User {
        guard let currentUser = _current else {
            fatalError("current user doesn't exist")
        }
        return currentUser
    }
    
    public static func setCurrent(_ user: User) {
        _current = user
    }
    
    init?(from dataSnapshot: DataSnapshot) {
        guard let data = dataSnapshot.value as? [String: Any],
            let name = data["name"] as? String,
            let uid = data["uid"] as? String else { //let officialPhotoURL = data["officialPhotoURL"] as? String
                return nil
        }
        
        self.uid = uid
        self.name = name
//        self.officialPhotoURL = officialPhotoURL
    }
    
}
