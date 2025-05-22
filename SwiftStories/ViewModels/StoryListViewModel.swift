//
//  StoryListViewModel.swift
//  SwiftStories
//
//  Created by Keval Vadoliya on 22/05/25.
//

import SwiftUI
import Combine

class StoryListViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var stories: [Story] = []
    @Published var isLoading = false
    @Published var currentPagee: Int = 1
    
    private let seenKey = "seenStories"
    private let likedKey = "likedStories"

    @Published var seenStoryIDs: Set<String> = []
    @Published var likedStoryIDs: Set<String> = []
    
    init() {
        loadPersistence()
    }
    
    func fetchUsers(from fileName: String = "users") {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let userData = try? JSONDecoder().decode(UsersData.self, from: data) else {
            return
        }
        self.users = userData.pages.flatMap{ $0.users }
    }
    
    func fetchPhotos(page: Int = 1, limit: Int = 5) async {
        
        guard !isLoading else { return }
        await MainActor.run {
            isLoading = true
        }
        
        guard let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=\(limit)") else {
            return
        }
        do {
            var urlRequest = URLRequest(url: url, timeoutInterval: 60)
            urlRequest.setValue("SwiftStoriesApp/1.0", forHTTPHeaderField: "User-Agent")
            
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 60
            config.timeoutIntervalForResource = 120
            let session = URLSession(configuration: config)
            
            let (data, _) = try await session.data(for: urlRequest)
            let photos = try JSONDecoder().decode([Photo].self, from: data)
            await MainActor.run {
                let filteredUsers = self.users.prefix(photos.count)
                let newStoreis = zip(filteredUsers, photos).map { Story(user: $0.0, photo: $0.1)}
                stories.append(contentsOf: newStoreis)
                currentPagee += 1
                isLoading = false
                
            }
        } catch {
            // TODO: handle error
            await MainActor.run {
                isLoading = false
            }
            
        }
    }
    
    func markAsSeen(_ story: Story) {
        seenStoryIDs.insert(story.id)
        persistSeen()
    }
    
    func toggleLike(_ story: Story) {
        if likedStoryIDs.contains(story.id) {
            likedStoryIDs.remove(story.id)
        } else {
            likedStoryIDs.insert(story.id)
        }
        persistLike()
    }
    
    private func persistSeen() {
        UserDefaults.standard.set(Array(seenStoryIDs), forKey: seenKey)
    }
    
    private func persistLike() {
        UserDefaults.standard.set(Array(likedStoryIDs), forKey: likedKey)
    }
    
    private func loadPersistence() {
        let seen = UserDefaults.standard.stringArray(forKey: seenKey) ?? []
        seenStoryIDs = Set(seen)
            
        let liked = UserDefaults.standard.stringArray(forKey: likedKey) ?? []
        likedStoryIDs = Set(liked)
    }
    
}
