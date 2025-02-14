//
//  Categories.swift
//  Memo Cloud
//
//  Created by Rizwan Shah on 31/01/2025.
//

import Foundation

struct Categories: Codable {
    let id: Int
    let name: String
    let isDeleted: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isDeleted = "is_deleted"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

