# Blog App

A modern Flutter application for creating and sharing blog posts with a clean, minimalist design and dark theme UI.

## Features

- **Authentication System**
  - User sign up with email and password
  - User login functionality 
  - Persistent login state

- **Blog Management**
  - Create new blog posts with images
  - Add titles and content to posts
  - Categorize posts with topic tags
  - View estimated reading time
  - Browse all published blog posts
  - View detailed blog posts

- **User Interface**
  - Modern dark theme design
  - Gradient accents and borders
  - Responsive layout
  - Loading states and error handling
  - Smooth navigation between screens

## Technical Details

- Built with Flutter 
- Uses BLoC pattern for state management
- Implements clean architecture principles
- Integrates with Supabase backend
- Features local storage with Hive
- Handles offline capabilities
- Includes image picking and upload functionality

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure your Supabase credentials in `lib/core/secrets/app_secrets.dart`
4. Run the app using `flutter run`

## Dependencies

- flutter_bloc: State management
- supabase_flutter: Backend services
- get_it: Dependency injection
- hive: Local storage
- image_picker: Image selection
- And more...

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
