//
//  StoryListView.swift
//  SwiftStories
//
//  Created by Keval Vadoliya on 22/05/25.
//

import SwiftUI

struct StoryListView: View {
    
    @ObservedObject var viewModel: StoryListViewModel
    @State private var selectedStory: Story?
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.stories.indices, id: \.self) { index in
                            let story = viewModel.stories[index]
                            VStack(spacing: 8) {
                                AsyncImage(url: story.user.profilePictureURL!) { image in
                                    image.resizable()
                                } placeholder: {
                                    Circle().fill(Color.gray.opacity((0.3)))
                                }
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().inset(by: -2).stroke(viewModel.seenStoryIDs.contains(story.id) ? Color.gray.opacity(0.5) : Color.orange.opacity(0.7), lineWidth: 2)
                                )
                                .onTapGesture {
                                    selectedStory = story
                                    viewModel.markAsSeen(story)
                                }
                                Text(story.user.name ?? "")
                                    .font(.caption)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                            }
                            .onAppear {
                                if index == viewModel.stories.count - 1 && !viewModel.isLoading {
                                    Task {
                                        await viewModel.fetchPhotos(page: viewModel.currentPagee)
                                    }
                                }
                            }
                        }
                        if viewModel.isLoading {
                            ProgressView()
                        }
                    }
                    .padding()
                    .onAppear {
                        Task {
                            if viewModel.stories.isEmpty {
                                viewModel.fetchUsers()
                                await viewModel.fetchPhotos(page: viewModel.currentPagee)
                            }
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("SwiftStories")
                        .font(.system(size: 28, weight: .regular, design: .serif))
                        .italic()
                        .foregroundColor(.black)
                }
            }
            .sheet(item: $selectedStory) { story in
                StoryViewerView(story: story, isLiked: viewModel.likedStoryIDs.contains(story.id)) {
                    viewModel.toggleLike(story)
                }
            
            }
            
        }
        
    }
    
}

struct StoryViewerView: View {
    let story: Story
    let isLiked: Bool
    let onLikeToggle: () -> Void

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            AsyncImage(url: story.photo.downloadURL) { image in
                image.resizable()
                    .scaledToFit()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: story.photo.downloadURL)
            } placeholder: {
                Color.gray.opacity(0.2)
                    .overlay(ProgressView())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack(alignment: .trailing, spacing: 20) {
                Button(action: onLikeToggle) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.largeTitle)
                        .foregroundColor(isLiked ? .red : .white)
                        .padding()
                }

                Button("Close") {
                    dismiss()
                }
                .foregroundColor(.white)
                .padding(.horizontal)
            }
            .padding(.top, 40)
            .padding(.trailing, 20)
        }
    }
}



#Preview {
    StoryListView(viewModel: StoryListViewModel())
}
