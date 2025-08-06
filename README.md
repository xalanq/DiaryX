# DiaryX

[![Flutter](https://img.shields.io/badge/Flutter-3.32.0-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.1-blue.svg)](https://dart.dev/)
[![Android API](https://img.shields.io/badge/Android%20API-24+-green.svg)](https://developer.android.com/about/versions/nougat/android-7.0)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

DiaryX is a privacy-first, AI-powered digital journaling application built with Flutter. It leverages Google's Gemma 3n model through MediaPipe for completely offline, on-device AI processing, ensuring your personal thoughts and memories never leave your device.

## 🌟 Key Features

### 📝 Multimodal Content Capture
- **Text Moments**: Rich text journaling with AI-powered enhancement
- **Voice Recording**: Audio capture with real-time transcription
- **Photo Capture**: Image journaling with intelligent analysis
- **Video Recording**: Video moments with contextual understanding

### 🤖 On-Device AI Processing
- **Gemma 3n Integration**: Google's latest multimodal AI model via MediaPipe
- **Complete Privacy**: All AI processing happens locally on your device
- **Offline Functionality**: Full feature set without internet connectivity
- **Intelligent Enhancement**: AI-powered content expansion and insights

### 💬 AI Chat Companion
- **Conversational Interface**: Chat with your personal AI about your experiences
- **Context-Aware**: AI understands your journal history for meaningful conversations
- **Real-time Streaming**: Responsive AI interactions with streaming responses

### 📊 Personal Analytics
- **Mood Tracking**: Multi-dimensional emotional state analysis
- **Content Insights**: Writing patterns and frequency analysis
- **Visual Charts**: Beautiful data visualizations with FL Chart
- **Smart Tagging**: Automatic and manual content categorization

### 🔒 Privacy & Security
- **Local Storage**: SQLite database with encrypted secure storage
- **No Data Collection**: Zero telemetry or data sharing
- **Offline First**: Complete functionality without cloud dependencies

## 🛠 Technical Stack

### Frontend
- **Framework**: Flutter 3.32.0
- **Language**: Dart 3.8.1
- **State Management**: Provider
- **UI Components**: Material Design with custom themes

### Backend & AI
- **AI Engine**: Gemma 3n via MediaPipe LLM Inference
- **Database**: SQLite with Drift ORM
- **Local Storage**: Flutter Secure Storage
- **Media Processing**: Native camera, audio, and video handling

### Platform Support
- **Android**: API 24+ (Android 7.0 Nougat)
- **iOS**: iOS 12.0+
- **Architecture**: ARM64, x86_64

## 🏗 Architecture Overview

DiaryX follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── app.dart                    # App configuration and providers
├── main.dart                   # Application entry point
├── consts/                     # Constants and configuration
├── databases/                  # Drift database definitions
├── models/                     # Data models with Freezed
├── screens/                    # UI screens and pages
│   ├── capture/               # Content capture screens
│   ├── chat/                  # AI chat interface
│   ├── home/                  # Main dashboard
│   ├── timeline/              # Journal timeline
│   ├── insight/               # Analytics and insights
│   └── profile/               # User settings
├── services/                   # Business logic and services
│   ├── ai/                    # AI service implementation
│   │   ├── implementations/   # MediaPipe LLM engine
│   │   └── models/           # AI-related models
│   └── task/                  # Background task processing
├── stores/                     # State management
├── themes/                     # App theming
├── utils/                      # Utility functions
└── widgets/                    # Reusable UI components
```

### Key Components

- **AI Service**: Manages Gemma 3n model integration and streaming responses
- **MediaPipe Engine**: Native Android/iOS implementation for AI inference
- **Drift Database**: Type-safe SQLite ORM for local data persistence
- **Task Queue**: Universal background task processing system
- **Provider Stores**: Reactive state management for UI components

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.32.0 or higher
- **Dart SDK**: 3.8.1 or higher
- **Android Studio**: For Android development
- **Xcode**: For iOS development (macOS only)
- **Android NDK**: 27.0.12077973 (for MediaPipe native components)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/xalanq/DiaryX.git
   cd DiaryX
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   dart run build_runner build
   ```

4. **Setup MediaPipe Models**
   ```bash
   # Download Gemma 3n models (instructions in docs/)
   # Place models in platform-specific directories
   ```

### Running the App

```bash
# Development mode
flutter run

# Release mode
flutter run --release

# Specific platform
flutter run -d android
flutter run -d ios
```

### Building

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🧪 Development

### Code Generation

The project uses several code generation tools:

```bash
# Generate all code
dart run build_runner build

# Watch for changes
dart run build_runner watch

# Clean generated files
dart run build_runner clean
```

### Database Migrations

```bash
# Generate migration files
dart run drift_dev schema generate drift_schemas/app_database/
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Linting

```bash
# Analyze code
flutter analyze

# Fix formatting
dart format lib/ test/
```

## 📁 Project Structure

### Core Modules

- **`/lib/services/ai/`**: AI integration and model management
- **`/lib/databases/`**: Local data persistence layer
- **`/lib/models/`**: Data transfer objects and entity models
- **`/lib/stores/`**: Application state management
- **`/lib/screens/`**: User interface screens
- **`/lib/widgets/`**: Reusable UI components

### Platform-Specific Code

- **`/android/app/src/main/kotlin/`**: Android native MediaPipe integration
- **`/ios/Runner/`**: iOS native code (MediaPipe integration planned)

### Configuration

- **`pubspec.yaml`**: Dependencies and asset configuration
- **`analysis_options.yaml`**: Dart linting rules
- **`android/app/build.gradle.kts`**: Android build configuration

## 🔧 Configuration

### Environment Variables

Create `lib/consts/env_config.dart` with your configuration:

```dart
class EnvConfig {
  static const String appName = 'DiaryX';
  static const bool debugMode = false;
  // Add other configuration as needed
}
```

### AI Model Setup

1. Download Gemma 3n models from the official repository
2. Place models in the appropriate platform directories
3. Update model paths in `AIConfigService`

## 🤝 Contributing

We welcome contributions! Please read our contributing guidelines before submitting PRs.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart)
- Use `dart format` for consistent formatting
- Ensure `flutter analyze` passes without warnings
- Add tests for new features

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Google MediaPipe](https://mediapipe.dev/) for AI inference framework
- [Gemma 3n](https://ai.google.dev/gemma) for the multimodal AI model
- [Flutter Team](https://flutter.dev/) for the amazing cross-platform framework
- [Drift](https://drift.simonbinder.eu/) for type-safe database operations

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/xalanq/DiaryX/issues)
- **Discussions**: [GitHub Discussions](https://github.com/xalanq/DiaryX/discussions)
- **Email**: [Contact maintainer](mailto:xalanq@gmail.com)

---

**Made with ❤️ for privacy-conscious journaling**
