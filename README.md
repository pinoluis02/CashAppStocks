# CashAppStocks  <img width="60" alt="appcion_light" src="https://github.com/user-attachments/assets/6b7fa719-99f2-475d-bf9a-0c4a4dc51589" />


A lightweight iOS app that displays a portfolio of stocks using clean architecture principles, modern UIKit + SwiftUI patterns, and Combine.

## 🧠 Thought Process & Architectural Approach

The core goal was to balance simplicity with clarity, showcasing a real-world, scalable UIKit app enhanced with SwiftUI where appropriate.

</br>

## Architecture

- **MVVM (Model-View-ViewModel)**:
  - Separates concerns cleanly between UI (ViewController), business logic (ViewModel), and data (Model).
  - Improves testability (ViewModels and Services are unit-tested). 
  - If the number of screens increases, the structure can easily scale by integrating a Coordinator pattern to manage navigation and decouple flow logic from view controllers.
  
- **Modular Design**:
  - Features like Networking, ViewModels, Views, and Helpers are organized in dedicated folders.
  - Makes navigation and future scaling easier.

- **Dependency Injection via Factory**:
  - The `StockServiceFactory` centralizes configuration (e.g., endpoint switching), enabling flexibility and easier testing.

- **Combine**:
  - Used for reactive binding (e.g., `@Published searchQuery`) with `debounce` to reduce unnecessary filtering.
  - Ensures the UI stays in sync with model layer changes through `@Published state`, which represents loading, loaded, empty, or error states.

- **SwiftUI Interoperability**:
  - SwiftUI was leveraged in the `EmptyStateView`, `LoadingView`, `ErrorView` to demonstrate composability and modern UI practices within a UIKit-first app.
  - Demonstrates comfort with both technologies.
 

----

## 🎨 UI Showcase

| <img width="206" alt="List_Light" src="https://github.com/user-attachments/assets/5d52ee5a-86bf-4930-969f-7d48ac41e9e4" /> |<img width="206" alt="Details_Light" src="https://github.com/user-attachments/assets/0295160b-33e8-4dab-a660-a1f83ef44016" /> | <img width="206" alt="Settings_Light" src="https://github.com/user-attachments/assets/630bb107-8371-4f5d-9042-38aa8d3b6e9f" /> | <img width="206" alt="HomeScreen_Dark" src="https://github.com/user-attachments/assets/abcf2761-8db6-4eab-879e-99330819eb9a"/> |
|-------------------------------------|-------------------------------------|-------------------------------------|-------------------------------------|
| Stock List - Light                  | Detail Screen - Light               | Settings - Light                    | Erorr - Light                       |

| <img width="206" alt="List_Dark" src="https://github.com/user-attachments/assets/6fe59a58-d4e7-49d8-9523-332fee2cb55e" /> |<img width="206" alt="Details_Dark" src="https://github.com/user-attachments/assets/64258467-afa2-4a09-add3-8986fa2cc7a6" /> | <img width="206" alt="Settings_Dark" src="https://github.com/user-attachments/assets/7bc6820f-3445-47e9-a9af-2ff4a8f8541e" /> | <img width="206" alt="HomeScreen_Dark" src="https://github.com/user-attachments/assets/917193e3-50fd-4740-838d-dc71dcc7d0ae"/> |
|-------------------------------------|-------------------------------------|-------------------------------------|-------------------------------------|
| Stock List - Dark                   | Detail Screen - Dark                | Settings - Dark                     | Empty - Light                       |


----

</br>

### Tradeoffs & Decisions

| Tradeoff | Rationale |
|---------|-----------|
| **UIKit-first over SwiftUI-only** | UIKit offers more control and aligns with many existing production codebases. SwiftUI is used selectively where it shines. |
| **No third-party libraries** | Prioritized native APIs for simplicity, transparency, and portability. |
| **StockListViewModel `loadStocks()` marked as `@MainActor`** | Ensures UI state updates (like setting .loading or .error) happen safely on the main thread. This allows other parts of the ViewModel to remain thread-neutral, offering more flexibility in the future. |
| **Basic local caching** | Not implemented; assumed live call for simplicity. But caching could be added via URLCache or CoreData layer. |
| **Appearance (Theme Selection) in Settings** | Adds value and test flexibility between light, dark, or system theme, but could be seen as beyond scope—happy to remove or feature-flag. |

</br>

## 🛠 How to Run the Project

1. Clone the repo.
2. Open `CashAppStocks.xcodeproj` in Xcode 15+.
3. Run the app on any simulator or real device.

The app fetches real-time (static) JSON files from Google Cloud Storage to simulate:
- A full portfolio
- An empty response
- A malformed payload

These are configurable from the Settings screen.

## 🧪 Tests

The project includes unit tests for:
- `StockService`: including success, empty, and malformed payloads
- `StockViewModel`: computed presentation values
- `FormatterHelper`: price and date formatting
- `StockListViewModel`: basic state filtering (in progress)

## 💡 Highlights

- Error, Empty, and Loading state handling
- Search with debounce and filtering
- Dynamic theme switching (Light / Dark / System)
- Custom CardStyle for consistent presentation
- Mockable, testable architecture


## 🙌 Final Thoughts

This app is intentionally clean and concise to reflect good production practices without unnecessary complexity. I focused on:
- Solid architecture
- Testability
- Clear UI feedback
- Swift / UIKit proficiency



Thank you for reviewing! Happy to discuss further or walk through any part of the implementation.
