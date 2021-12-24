//
//  User.swift
//  login and password
//
//  Created by Ivan Karpovich on 23.12.21.
//

import Foundation

class User {
    var firstName: String
    var lastName: String
    var email: String
    var createdAt: String
    var lastLoginTime: String
    var status: String
    var databaseId: String
    var authId: String
    
    init (firstName: String, lastName: String, email: String, created: String, loginTime: String, status: String, databaseId: String, authId: String)
    {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.createdAt = created
        self.lastLoginTime = loginTime
        self.status = status
        self.databaseId = databaseId
        self.authId = authId
    }
}
