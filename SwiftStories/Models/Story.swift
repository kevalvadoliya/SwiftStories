//
//  Story.swift
//  SwiftStories
//
//  Created by Keval Vadoliya on 22/05/25.
//

import Foundation

struct Story: Identifiable, Hashable {
    var id: String {
        "\(user.id)-\(photo.id)"
    }
    let user: User
    let photo: Photo
}
