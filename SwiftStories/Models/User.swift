//
//  User.swift
//  SwiftStories
//
//  Created by Keval Vadoliya on 22/05/25.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: Int
    let name: String?
    let profilePictureURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePictureURL = "profile_picture_url"
    }
}

struct UserPage: Codable {
    let users: [User]
}

struct UsersData: Codable {
    let pages: [UserPage]
}
