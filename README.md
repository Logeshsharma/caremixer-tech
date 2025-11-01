# Caremixer

A Flutter application featuring timeline events UI, Pokemon browsing, and chat functionality with modern UI/UX design.

## Video

## Features

### Timeline Screen
- **Modern Design**: Card-based layout with timeline visualization

### Pokemon Screen
- **Search & Filter**: Real-time search with debouncing
- **Infinite Scroll**: Automatic pagination with smooth loading
- **Scroll to Top**: Quick navigation with floating action button
- **Cached Images**: Fast image loading with caching

### Chat Screen
- **Real-time Messaging**: Instant message display
- **Bot Simulation**: Automated responses with typing indicator

## Getting Started

### Prerequisites

- **Flutter SDK**: Version 3.32.1 or higher
- **Dart SDK**: Version 3.8.1 or higher
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **Device/Emulator**: iOS Simulator, Android Emulator, or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd caremixer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter installation**
   ```bash
   flutter doctor
   ```
   Ensure all required components are installed.

### Running the App

#### Option 1: Using Command Line

**Run on connected device/emulator:**
```bash
flutter run
```

**Run on specific device:**
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

**Run in release mode:**
```bash
flutter run --release
```

#### Option 2: Using IDE

**VS Code:**
1. Open the project in VS Code
2. Press `F5` or click "Run > Start Debugging"
3. Select your target device from the status bar

**Android Studio:**
1. Open the project in Android Studio
2. Select your target device from the device dropdown
3. Click the "Run" button or press `Shift + F10`

### Platform-Specific Setup

#### iOS
```bash
cd ios
pod install
cd ..
flutter run
```

#### Android
No additional setup required. Just run:
```bash
flutter run
```


## Dependencies

### Core Dependencies
- **flutter_riverpod** (^2.6.1) - State management
- **dio** (^5.7.0) - HTTP client for API calls
- **retrofit** (^4.4.1) - Type-safe REST client
- **cached_network_image** (^3.4.1) - Image caching
- **intl** (^0.20.2) - Date formatting
- **connectivity_plus** (^6.1.0) - Network connectivity monitoring
- **go_router** (^16.0.0) - Screen routing


## Project Structure

```
lib/
├── data/                             # Data layer
│   ├── models/                       # Data models
│   │   ├── pokemon.dart
│   │   └── timeline_event.dart
│   └── repositories/                 # Data repositories
│       └── pokemon_repository.dart
├── domain/                           # Business logic layer
│   └── usecases/                     # Use cases
├── ui/                               # Presentation layer
│   ├── chat/                         # Chat feature
│   │   ├── models/
│   │   ├── providers/
│   │   └── widgets/
│   ├── core/                         # Shared UI components
│   │   ├── constants/                # App-wide constants
│   │   │   └── app_colors.dart
│   │   └── ui/                       # Reusable widgets
│   ├── home/                         # Home screen with navigation
│   ├── pokemon_list/                 # Pokemon feature
│   │   ├── providers/
│   │   ├── utils/
│   │   └── widgets/
│   └── timeline_list/                # Timeline feature
│       └── widgets/
├── utils/                            # Utility functions
└── main.dart                         # App entry point
```

## State Management Approach

### **Riverpod** - Chosen State Management Solution

This project uses **Flutter Riverpod** for state management.

#### Why Riverpod?

1. **Compile-time Safety**
   - Catches errors at compile time, not runtime
   - Type-safe provider access
   - No `BuildContext` required for most operations


3. **Performance**
   - Fine-grained reactivity - only rebuilds affected widgets
   - Automatic disposal of unused providers
   - Efficient state updates

4. **Developer Experience**
   - Clear separation of concerns
   - Easy to understand and maintain


#### Best Practices Used

1. **Immutable State**: All state classes use immutable properties
2. **Single Responsibility**: Each provider has one clear purpose
3. **Separation of Concerns**: Data, UI, and business logic are separated
4. **Provider Composition**: Providers can depend on other providers
5. **Automatic Disposal**: Providers are automatically disposed when not needed
6. **Error Handling**: Proper error states in all providers


## Build

### Android APK
```bash
flutter build apk --release
```

### iOS IPA
```bash
flutter build ios --release
```


## API Integration

The app uses the **PokeAPI** (https://pokeapi.co/) for Pokemon data:
- Endpoint: `https://pokeapi.co/api/v2/pokemon`
- Pagination: 20 items per page


### Author
Logesh Sharma
