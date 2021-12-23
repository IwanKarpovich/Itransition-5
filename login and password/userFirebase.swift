//
//  userFirebase.swift
//  login and password
//
//  Created by Ivan Karpovich on 21.12.21.
//

import Foundation
import FirebaseFirestore

extension appUser {
    static func build(from documents: [QueryDocumentSnapshot]) -> [appUser] {
        var user = [appUser]()
        for document in documents {
            user.append(appUser (last: document["last"] as? String ?? "",
                              uid: document["uid"] as? String ?? ""))
        }
        return user
    }
}
