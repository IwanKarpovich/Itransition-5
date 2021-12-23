//
//  userService.swift
//  login and password
//
//  Created by Ivan Karpovich on 21.12.21.
//

import Foundation
import FirebaseFirestore

class UserService {
    let database = Firestore.firestore()

    func get(collectionID: String, handler: @escaping ([appUser]) -> Void) {
        database.collection("users")
            .addSnapshotListener { querySnapshot, err in
                if let error = err {
                    print(error)
                    handler([])
                } else {
                    handler(appUser.build(from: querySnapshot?.documents ?? []))
                }
            }
    }
}
