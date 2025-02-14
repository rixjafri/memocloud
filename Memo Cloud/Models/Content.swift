//
//  Content.swift
//  Memo Cloud
//
//  Created by Rizwan Shah on 12/02/2025.
//

import Foundation

struct Contents: Codable {
    let id: Int
    let userId: Int
    let categoryIds: String?
    let categoriesNames: String?
    let refNo: String
    let title: String
    let description: String
    let type: Int
    let createdAt: String
    let updatedAt: String
    let mediaInfo: [MediaInfo]?
    let categories: [ContentCategory]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case categoryIds = "category_ids"
        case categoriesNames = "category_names"
        case refNo = "ref_no"
        case title
        case description
        case type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mediaInfo = "media"
        case categories
    }
}

struct MediaInfo: Codable {
    let id: Int
    let contentId: Int
    let path: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case contentId = "content_id"
        case path
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


struct ContentCategory: Codable {
    let id: Int
    let categoryId: Int
    let contentId: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id"
        case contentId = "content_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

