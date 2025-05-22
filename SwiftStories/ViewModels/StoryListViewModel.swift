//
//  StoryListViewModel.swift
//  SwiftStories
//
//  Created by Keval Vadoliya on 22/05/25.
//

import SwiftUI

class StoryListViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var photos: [Photo] = []
    @Published var isLoading = false
    @Published var currentPagee = 1
    
    func fetchUsers(from fileName: String = "users") {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let userData = try? JSONDecoder().decode(UsersData.self, from: data) else {
            return
        }
        self.users = userData.pages.flatMap{ $0.users }
    }
    
    func fetchPhotos(page: Int = 1, limit: Int = 20) async {
        
        guard !isLoading else { return }
        await MainActor.run {
            isLoading = true
        }
        
        guard let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=\(limit)") else {
            return
        }
        do {
            let urlRequest = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            self.photos = try JSONDecoder().decode([Photo].self, from: data)
            await MainActor.run {
                isLoading = true
            }
        } catch {
            await MainActor.run {
                isLoading = true
            }
        }
    }
    
}
