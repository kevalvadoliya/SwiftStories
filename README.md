## Architectural Decisions

- Followed **MVVM** architecture to keep UI and business logic separate.
- Used **Swift Concurrency (`async/await`)** for handling asynchronous API calls instead of Combine.
- Built UI using **SwiftUI** to support modern, declarative design.
- Managed **seen** and **liked** states using `UserDefaults` for simple local persistence.
- Did not use any third-party libraries for core features to keep the project lightweight and maintainable.

## Assumptions and Limitations

- User data is loaded from a local JSON file included in the app bundle.
- Photos are fetched from `https://picsum.photos` using pagination.
- Unique story ID is created by combining the `user.id` and `photo.id`.
- Story seen/liked states are tracked using the generated story ID.
- The app is designed for iPhone only and supports portrait orientation.