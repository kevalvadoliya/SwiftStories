//
//  StoryListViewModel.swift
//  SwiftStories
//
//  Created by Keval Vadoliya on 22/05/25.
//

import SwiftUI

class StoryListViewModel: ObservableObject {
    
    @Published var users: [User] = []
    
    func fetchUsers(from fileName: String = "users") {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let userData = try? JSONDecoder().decode(UsersData.self, from: data) else {
            return
        }
        self.users = userData.pages.flatMap{ $0.users }
    }
    
}
