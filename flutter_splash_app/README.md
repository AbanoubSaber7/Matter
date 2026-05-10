# Flutter Splash App

This project is a Flutter application that demonstrates a splash screen with navigation based on the user's login state. The app checks if the user is logged in and navigates to either the login screen or a detection screen that displays personalized content.

## Project Structure

```
flutter_splash_app
├── lib
│   ├── main.dart                # Entry point of the application
│   ├── app.dart                 # Main application widget with routing
│   ├── screens
│   │   ├── splash_screen.dart   # Splash screen implementation
│   │   ├── login_screen.dart    # User login interface
│   │   └── detection_screen.dart # Screen displaying user-specific content
│   ├── services
│   │   └── auth_service.dart    # Authentication logic
│   ├── widgets
│   │   └── common_widgets.dart   # Commonly used widgets
│   └── models
│       └── user.dart            # User model definition
├── test
│   └── widget_test.dart         # Widget tests for the application
├── pubspec.yaml                 # Project configuration and dependencies
├── analysis_options.yaml        # Dart analysis options
└── README.md                    # Project documentation
```

## Getting Started

To run this project, ensure you have Flutter installed on your machine. Follow these steps:

1. Clone the repository:
   ```
   git clone <repository-url>
   cd flutter_splash_app
   ```

2. Install the dependencies:
   ```
   flutter pub get
   ```

3. Run the application:
   ```
   flutter run
   ```

## Features

- Splash Screen: A visually appealing splash screen that appears when the app starts.
- Authentication: Checks the user's login state and navigates accordingly.
- User Interface: Simple and intuitive UI for logging in and viewing personalized content.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any suggestions or improvements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.