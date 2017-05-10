//
//  Comment.swift
//  Firegram
//
//  Created by Nithin Reddy Gaddam on 5/3/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
    let text: String
//    let uid: String
    let creationDate: Date
    let user: User
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
//        self.uid = dictionary["uid"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
