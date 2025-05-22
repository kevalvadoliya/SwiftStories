//
//  Item.swift
//  SwiftStories
//
//  Created by Keval Vadoliya on 22/05/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
