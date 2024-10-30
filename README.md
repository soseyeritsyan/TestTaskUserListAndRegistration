# TestAppSoseYeritsyan

This is a test project demonstrating API requests, data handling, and UI components in Swift. The app includes user registration, displaying a list of users, and handling network connectivity.

---

## Configuration Options

This section outlines the configurable settings in the project and how to modify them.

1. **API Endpoints**:
   - API base URL and endpoints in `DataManager.swift`.

2. **Authentication Tokens**:
   - The `getToken` function in `DataManager.swift` retrieves an authentication token. Ensure the token is retrieved before calling `registerUser` 

3. **Fonts**:
   - Custom fonts (Nunito-Regular and Nunito-SemiBold) are included in the project. You can replace these fonts with others by adding new font files in the `Fonts` folder and updating the `Info.plist` to recognize the new font files.

4. **UI Customization**:
   - Modify the color scheme, fonts, or image assets in `Assets.xcassets`.
   - UI configurations like corner radius can be adjusted in `ViewController` files (e.g., `SignUpViewController.swift`).

---

## Dependencies

This project uses a few third-party libraries to enhance development:

- **Kingfisher** - for image downloading and caching.

Dependencies are managed through Swift Package Manager (SPM). To add or update libraries, use SPM in Xcode under **File > Swift Packages > Add Package Dependency**.

---

## Project Structure

The project is organized as follows:

- **AppDelegate.swift**: Manages app lifecycle events and initial setup.
  
- **Cells/**: Contains custom table view cells.
  - **UserTableViewCell**: Displays user information in the user list.
  - **PositionTableViewCell**: Displays position information when selecting a user position.

- **Fonts/**: Stores custom font files used throughout the app.

- **Model/**: Contains data models for handling API responses.
  - **GetTokenResponse.swift**: Model(s) for the token response.
  - **Position.swift**: Model(s) for user position data.
  - **RegisterUserResponse.swift**: Model(s) for the registration response.
  - **UserModel.swift**: Model(s) representing user details.

- **View/**:
  - **NoInternetView**: Custom view shown when there is no internet connection, with a retry button to reload data.

- **ViewController/**:
  - **CustomViewController.swift**: Base view controller class for this project.
  - **ResultViewController.swift**: Shows results of certain operations, like registration success.
  - **SignUpViewController.swift**: Handles user registration, allowing users to input details and submit the signup request.
  - **UsersViewController.swift**: Displays a paginated list of users and manages fetching user data.

- **NetworkMonitor.swift**: Monitors network connectivity and notifies the app when the connection status changes.

- **DataManager.swift**: Manages API requests and responses, including token management and user registration.

- **Assets.xcassets**: Contains images, colors, and other assets.

- **Info.plist**: Stores metadata and configuration details about the app.

- **LaunchScreen.storyboard**: Defines the initial screen shown on app launch.

- **Main.storyboard**: Contains the main UI layout and navigation structure.

- **SceneDelegate.swift**: Manages scene lifecycle for multi-window support.

---

## Troubleshooting

Below are some common issues and solutions.

1. **API Request Failures**:
   - Ensure the base URL is correct and check for a stable internet connection.
   - Confirm that the token is being retrieved and used correctly.

2. **Image Downloading Issues**:
   - If images do not load, ensure that the URL is valid, and check that Kingfisher is installed and configured correctly.

3. **UI Layout Problems**:
   - For layout-related issues, use Xcode’s “View Debugging” tool to inspect the layout in real-time.
   - Ensure fonts are properly registered in `Info.plist` if custom fonts are not displaying as expected.

