//
//  StoryListView.swift
//  SwiftStories
//
//  Created by Keval Vadoliya on 22/05/25.
//

import SwiftUI

struct StoryListView: View {
    
    @ObservedObject var viewModel: StoryListViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                Task {
                    viewModel.fetchUsers()
                    await viewModel.fetchPhotos()
                }
            }
    }
}

#Preview {
    StoryListView(viewModel: StoryListViewModel())
}
