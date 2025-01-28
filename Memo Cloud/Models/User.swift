//
//  LoginModel.swift
//  JJSystems
//
//  Created by Rizwan Shah on 22/10/2024.
//

import Foundation

struct UserData: Codable {
    var user: User
    let token: String
}

struct User: Codable {
    let userId: Int
    let firstName: String
    let lastName: String
    let email: String
    let differentUsername: Int
    let username: String
    let role: String
    let currentWorkspace: String
    let phone: String
    let image: String?  // Optional for nullable field
    let whatsappNo: String
    let address: String
    let countryId: Int
    let addedBy: Int
    let createdAt: String
    let updatedAt: String
    let updatedBy: Int
    let deletedAt: String? // Optional for nullable field
    let emailVerifiedAt: String? // Optional for nullable field
    let phoneVerifiedAt: String? // Optional for nullable field
    let twoFA: Int?
    let showPrice: Int
    let showOnlyMukechi: Int
    let showOnlySaleReport: Int
    let days: Int
    var defaultCountryId: Int?
    let systemRights: [SystemRight] // New array
    let reports: [Report] // New array

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case differentUsername = "different_username"
        case username
        case role
        case currentWorkspace = "current_workspace"
        case phone
        case image
        case whatsappNo = "whatsapp_no"
        case address
        case countryId = "country_id"
        case addedBy = "added_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case updatedBy = "updated_by"
        case deletedAt = "deleted_at"
        case emailVerifiedAt = "email_verified_at"
        case phoneVerifiedAt = "phone_verified_at"
        case twoFA = "twoFA"
        case showPrice = "show_price"
        case showOnlyMukechi = "show_only_mukechi"
        case showOnlySaleReport = "show_only_sale_report"
        case days
        case defaultCountryId = "default_country"
        case systemRights = "system_rights"
        case reports
    }
}

struct SystemRight: Codable {
    let systemId: Int
    let userId: Int
    let externalUserId: Int? // Optional for nullable field
    let name: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case systemId = "system_id"
        case userId = "user_id"
        case externalUserId = "external_user_id"
        case name, status
    }
}

struct Report: Codable {
    let id: Int
    let name: String
    

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}


