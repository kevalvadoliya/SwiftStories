//
//  Photo.swift
//  SwiftStories
//
//  Created by Keval Vadoliya on 22/05/25.
//

import Foundation

struct Photo: Codable {
    let id: String
    let downloadURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case downloadURL = "download_url"
    }
}
