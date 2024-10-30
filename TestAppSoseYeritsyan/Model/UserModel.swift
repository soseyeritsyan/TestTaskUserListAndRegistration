//
//  UserModel.swift
//  TestAppSoseYeritsyan
//
//  Created by sose yeritsyan on 22.10.24.
//

import UIKit

struct UserModel: Codable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let positionId: Int
    let registrationTimestamp: Int
    let photo: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phone
        case position
        case positionId = "position_id"
        case registrationTimestamp = "registration_timestamp"
        case photo
    }
}

// Users list models

struct UsersResponse: Codable {
    let success: Bool
    let page: Int
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let links: Links
    let users: [UserModel]
    
    private enum CodingKeys: String, CodingKey {
        case success
        case page
        case totalPages = "total_pages"
        case totalUsers = "total_users"
        case count
        case links
        case users
    }
}

struct Links: Codable {
    let nextUrl: String?
    let prevUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case nextUrl = "next_url"
        case prevUrl = "prev_url"
        
    }
}

