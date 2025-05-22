//
//  SwiftStoriesApp.swift
//  SwiftStories
//
//  Created by Keval Vadoliya on 22/05/25.
//

import SwiftUI

@main
struct SwiftStoriesApp: App {
    
    @ObservedObject private var viewModel = StoryListViewModel()

    var body: some Scene {
        WindowGroup {
            StoryListView(viewModel: viewModel)
        }
    }
}
