//
//  LoginResponse.swift
//  EmpBook
//
//  Created by A118830248 on 10/10/22.
//

import Foundation

// MARK: - Welcome
struct LoginResponse: Codable {
    var access: String?
    var refresh: String?
    var user: User?
    
    enum CodingKeys: String, CodingKey {
        case access
        case refresh
        case user
    }
    
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let firstName, lastName, email: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
}
