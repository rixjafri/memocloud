//
//  LoginModel.swift
//  MemoCloud
//
//  Created by Rizwan Shah on 22/10/2024.
//

import Foundation


struct noData: Codable {
    let success: Bool
    let message: String
}

struct UserData: Codable {
    let success: Bool
    let message: String
    let data: User
    let token: String
}

struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let password: String
    let role: Int = 0
    let status: Int
    let isDeleted: Int = 0
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case password
        case role
        case status
        case isDeleted = "is_deleted"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

