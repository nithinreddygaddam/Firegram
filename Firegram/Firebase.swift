//
//  Firebase.swift
//  Firegram
//
//  Created by Nithin Reddy Gaddam on 4/30/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//

import Foundation
import Firebase

extension FIRDatabase {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()){
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {
            (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any]
                else{return}
            
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
            
        }) { (err) in
            print("Failed to feth user for posts", err)
        }
    }
}
